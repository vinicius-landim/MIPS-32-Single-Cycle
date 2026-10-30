module mips_processor(
    input logic clk, read_clk,
    input logic reset, btn_io,
    input logic [31:0] input_data,
    output logic [31:0] output_data,
    output logic flag_in, flag_out, flag_halt, flag_olcd
);
    logic [31:0] pc_addr;
    logic [31:0] pc_next_addr;
    logic [31:0] reg2_data;
    logic [31:0] inst;
    logic [31:0] inst_imm_extended, alu_Y , mem_data, reg1_data, alu_data;
    logic [31:0] write_back_data;
    logic [31:0] hd_data;
    logic [31:0] kernel_pc;
    logic [31:0] dm_base;
    logic [13:0] dm_addr;
    logic [10:0] im_base;
    logic [10:0] im_read_addr;
    logic [4:0] write_reg_addr;
    logic [3:0] flag_alu_operation;
    logic [2:0] flag_branch_type, flag_alu_op, flag_write_back;
    logic [1:0] flag_regdst;
    logic flag_regwrite, flag_jump, flag_alu_src, flag_memwrite, flag_memread, flag_instwrite;
    logic flag_jumpreg, flag_branch, flag_io_stall;
    logic flag_zero, flag_less;
    logic flag_hdread;
    logic flag_runp;
    logic flag_endp;
    logic flag_sysmode;
    logic flag_setbase;

    assign output_data = reg1_data;

    pc_update_logic pc_update_logic(
        .pc_current(pc_addr),
        .reg1_data(reg1_data),
        .inst_target(inst[25:0]),
        .inst_offset(inst_imm_extended),
        .jumpreg(flag_jumpreg),
        .branch(flag_branch),
        .jump(flag_jump),
        .pc_next(pc_next_addr)
    );

    program_counter program_counter(
        .clk(clk),
        .reset(reset),
        .halt(flag_halt),
        .clk_manual(btn_io),
        .io_stall(flag_io_stall),
        .flag_endp(flag_endp),
        .kernel_pc(kernel_pc),
        .pc_in(pc_next_addr),
        .pc_out(pc_addr)
    );

    control_unit control_unit(
        .inst_op(inst[31:26]),
        .writeback(flag_write_back),
        .branch_type(flag_branch_type),
        .aluop(flag_alu_op),
        .regdst(flag_regdst),
        .jump(flag_jump),
        .memread(flag_memread),
        .memwrite(flag_memwrite),
        .alusrc(flag_alu_src),
        .regwrite(flag_regwrite),
        .out(flag_out),
        .in(flag_in),
        .halt(flag_halt),
        .io_stall(flag_io_stall),
        .olcd(flag_olcd),
        .hdread(flag_hdread),
        .instwrite(flag_instwrite),
        .runp(flag_runp),
        .endp(flag_endp),
        .setbase(flag_setbase)
    );

    system_registers system_registers(
        .clk(clk),
        .reset(reset),
        .in_dm_base(reg1_data),
        .in_kernel_pc(pc_addr + 1),
        .flag_runp(flag_runp),
        .flag_endp(flag_endp),
        .sys_mode(flag_sysmode),
        .out_dm_base(dm_base),
        .out_kernel_pc(kernel_pc)
    );

    assign im_base = flag_sysmode ? 11'd1024 : 11'd0;
    assign im_read_addr = {flag_sysmode, pc_addr[9:0]}; //1024 + pc

    instruction_RAM instruction_memory(
        .read_clock(read_clk),
        .write_clock(clk),
        .read_addr(im_read_addr),
        .write_addr(alu_data[10:0]),
        .flag_instwrite(flag_instwrite),
        .inst_in(reg2_data),
        .inst_out(inst)
    );

    mux_write_reg mux_write_reg(
        .regdst(flag_regdst),
        .inst_rt(inst[20:16]),
        .inst_rd(inst[15:11]),
        .reg31_addr(5'b11111),
        .mux_out(write_reg_addr)
    );

    register_file register_file(
        .reg1_addr(inst[25:21]),
        .reg2_addr(inst[20:16]),
        .write_reg_addr(write_reg_addr),
        .write_data(write_back_data),
        .reg1_data(reg1_data),
        .reg2_data(reg2_data),
        .clk(clk),
        .regwrite(flag_regwrite)
    );

    hard_disk hd(
        .hd_in(31'b0),
        .track(reg1_data[9:0]),
        .sector(reg2_data[9:0]),
        .read_clock(read_clk),
        .write_clock(clk),
        .flag_hdread(flag_hdread),
        .flag_hdwrite(1'b0),
        .hd_out(hd_data)
    );

    sign_extension sign_extension_imm(
        .inst_imm(inst[15:0]),
        .inst_imm_extended(inst_imm_extended)
    );

    mux_2to1 mux_alusrc(
        .data1(reg2_data),
        .data2(inst_imm_extended),
        .flag(flag_alu_src),
        .mux_out(alu_Y)
    );

    ALU_control ALU_control(
        .inst_funct(inst[5:0]),
        .ALUop(flag_alu_op),
        .ALUoperation(flag_alu_operation),
        .jumpreg(flag_jumpreg)
    );

    ALU ALU(
        .X(reg1_data),
        .Y(alu_Y),
        .shamt(inst[10:6]),
        .op(flag_alu_operation),
        .alu_out(alu_data),
        .zero(flag_zero),
        .less(flag_less)
    );

    branch_logic_unit branch_logic_unit(
        .branch_type(flag_branch_type),
        .alu_less(flag_less),
        .alu_zero(flag_zero),
        .branch(flag_branch)
    );

    assign dm_addr = dm_base + alu_data;

    data_RAM data_memory(
        .read_addr(dm_addr[13:0]),
        .write_addr(dm_addr[13:0]),
        .data(reg2_data),
        .read_clk(read_clk),
        .write_clk(clk),
        .memwrite(flag_memwrite),
        .memread(flag_memread),
        .mem_out(mem_data)
    );

    mux_write_back mux_write_back(
        .write_back(flag_write_back),
        .mem_data(mem_data),
        .alu_data(alu_data),
        .pc_plus_one(pc_addr + 1),
        .input_data(input_data),
        .rs_data(reg1_data),
        .hd_data(hd_data),
        .mux_out(write_back_data),
    );

endmodule