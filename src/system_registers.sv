module system_registers (
    input logic clk, reset,
    input logic [31:0] in_dm_base,
    input logic [31:0] in_kernel_pc,
    input logic flag_setbase,
    input logic flag_runp,
    input logic flag_endp,
    output logic sys_mode,
    output logic [31:0] out_dm_base,
    output logic [31:0] out_kernel_pc
);
    parameter KERNEL_MODE = 0;
    parameter USER_MODE = 1;

    logic sys_mode_reg;
    logic [31:0] dm_base_reg;
    logic [31:0] kernel_pc_reg;

    always_ff @(posedge clk or posedge reset) begin
        if(reset) begin
            sys_mode_reg <= KERNEL_MODE;
            dm_base_reg <= 32'b0;
        end 
        else begin
            if(flag_runp) begin
                sys_mode_reg <= USER_MODE;
                kernel_pc_reg <= in_kernel_pc;
            end
            else if(flag_endp) begin
                sys_mode_reg <= KERNEL_MODE;
            end
            else if(flag_setbase) begin
                dm_base_reg <= in_dm_base;
            end

        end
    end

    assign sys_mode = sys_mode_reg;
    assign out_dm_base = dm_base_reg;
    assign out_kernel_pc = kernel_pc_reg;
    
endmodule