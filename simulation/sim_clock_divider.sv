`timescale 1ns / 1ps
// fpga4student.com FPGA projects, VHDL projects, Verilog projects
// Verilog project: Verilog code for clock divider on FPGA
// Testbench Verilog code for clock divider on FPGA
module sim_clock_divider;
    // Inputs
    logic clk_in;
    // Outputs
    logic clk_out;
    // Instantiate the Unit Under Test (UUT)
    // Test the clock divider in Verilog
    clock_divider uut (
        .clk_in(clk_in), 
        .clk_out(clk_out)
    );
    initial begin
    // Initialize Inputs
    clk_in = 0;
    // create input clock 50MHz
        forever #10 clk_in = ~clk_in;
    end
    
endmodule