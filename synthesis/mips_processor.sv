module mips_processor(
    input logic clk, read_clk,
    input logic reset, btn_io,
    input logic [15:0] switches,
    input logic sw_negative,
    output logic [31:0] data_out,
    output logic flag_in, flag_out, flag_negative, flag_halt
);

    logic [31:0] pc_addr;
    logic [31:0] pc_next_addr;
    logic [31:0] reg2_data;
    logic [31:0] inst;
    logic [31:0] inst_imm_extended, alu_Y , mem_data, reg1_data, alu_data;
    logic [31:0] input_sw, input_data;
    logic [4:0] write_reg_addr;
    logic [3:0] flag_alu_operation;
    logic [2:0] flag_branch_type, flag_alu_op, flag_write_back;
    logic [1:0] flag_regdst;
    logic flag_regwrite, flag_jump, flag_alu_src, flag_memwrite, flag_memread;
    logic flag_jumpreg, flag_branch, flag_io_stall;
    logic flag_zero, flag_less;

    assign input_sw = {16'b0, switches};
    assign input_data = sw_negative ? (~input_sw + 32'd1) : input_sw;

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
        .pc_in(pc_next_addr),
        .pc_out(pc_addr)
    );

    instruction_ROM instruction_memory(
        .clk(read_clk),
        .addr(pc_addr[7:0]),
        .inst_code(inst)
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
        .io_stall(flag_io_stall)
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
        .write_data(data_out),
        .reg1_data(reg1_data),
        .reg2_data(reg2_data),
        .clk(clk),
        .regwrite(flag_regwrite)
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

    data_RAM data_memory(
        .read_addr(alu_data[9:0]),
        .write_addr(alu_data[9:0]),
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
        .mux_out(data_out)
    );

    assign flag_negative = data_out[31];

endmodule
