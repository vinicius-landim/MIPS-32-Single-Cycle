module io_unit(
    input logic clk,
    input logic clk_processor,
    input logic reset,
    input logic flag_in,
    input logic flag_out,
    input logic flag_olcd,
    input logic [31:0] data1_from_cpu,
    input logic [31:0] data2_from_cpu,
    output logic [31:0] data_to_cpu,
    input logic [15:0] switches_in,
    input logic sw_negative_in,
    output logic [6:0] HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0,
    output logic LCD_ON, LCD_BLON, LCD_RW, LCD_EN, LCD_RS,
    inout wire [7:0] LCD_DATA
);

    switches_input switches_input(
        .switches(switches_in),
        .sw_negative(sw_negative_in),
        .data_to_cpu(data_to_cpu)
    );

    seven_seg_output seven_seg_output(
        .clk_processor(clk_processor),
        .reset(reset),
        .flag_in(flag_in),
        .flag_out(flag_out),
        .data_from_cpu(data1_from_cpu),
        .switches_in(switches_in),
        .sw_negative_in(sw_negative_in),
        .HEX6(HEX6), .HEX5(HEX5), .HEX4(HEX4),
        .HEX3(HEX3), .HEX2(HEX2), .HEX1(HEX1),
        .HEX0(HEX0)
    );

    LCD_output lcd_output(
        .clk(clk),
        .clk_processor(clk_processor),
        .reset(reset),
        .flag_olcd(flag_olcd),
        .msg_from_cpu(data1_from_cpu),
        .arg_from_cpu(data2_from_cpu),
        .LCD_ON(LCD_ON),
        .LCD_BLON(LCD_BLON),
        .LCD_RW(LCD_RW),
        .LCD_EN(LCD_EN),
        .LCD_RS(LCD_RS),
        .LCD_DATA(LCD_DATA)
    );

endmodule