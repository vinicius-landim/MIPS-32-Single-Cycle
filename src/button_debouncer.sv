//fpga4student.com: FPGA projects, Verilog projects, VHDL projects
// Verilog code for button debouncing on FPGA
// debouncing module without creating another clock domain
// by using clock enable signal 
module button_debouncer(
    input logic btn_1, clk,
    output logic btn_out
);

    logic slow_clk_en;
    logic Q1, Q2, Q2_bar, Q0;
    clock_enable u1(clk,slow_clk_en);
    debounce_dff_en d0(clk,slow_clk_en,btn_1,Q0);

    debounce_dff_en d1(clk,slow_clk_en,Q0,Q1);
    debounce_dff_en d2(clk,slow_clk_en,Q1,Q2);
    assign Q2_bar = ~Q2;
    assign btn_out = Q1 & Q2_bar;
endmodule