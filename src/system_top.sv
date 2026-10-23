module system_top(
    input logic clk, read_clk,
    input logic reset, btn_io,
    input logic [15:0] switches,
    input logic sw_negative,
    output logic input_led, output_led, halt_led,
    output logic [17:0] data_led,
    output logic [6:0] HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0,
    output logic LCD_ON, LCD_BLON, LCD_RW, LCD_EN, LCD_RS,
    inout wire [7:0] LCD_DATA 
);
    logic [31:0] cpu_data_in, cpu_data_out;
    logic flag_in, flag_out, flag_negative, flag_olcd;
    logic btn_debounced, clk_processor;

    assign input_led = flag_in;
    assign output_led = flag_out;

    clock_divider clk_divider(
        .clk_in(clk),
        .clk_out(clk_processor)
    );

    button_debouncer btn_debouncer(
        .btn_1(btn_io),
        .clk(clk),
        .btn_out(btn_debounced)
    );

    mips_processor mips(
        .clk(clk_processor),
        .read_clk(read_clk),
        .btn_io(btn_debounced),
        .reset(reset),
        .input_data(cpu_data_in),
        .output_data(cpu_data_out),
        .flag_in(flag_in),
        .flag_out(flag_out),
        .flag_olcd(flag_olcd),
        .flag_halt(halt_led)
    );

    io_unit io_controller(
        .clk(clk),
        .clk_processor(clk_processor),
        .reset(reset),
        .flag_in(flag_in),
        .flag_out(flag_out),
        .flag_olcd(flag_olcd),
        .data_from_cpu(cpu_data_out),
        .data_to_cpu(cpu_data_in),
        .switches_in(switches),
        .sw_negative_in(sw_negative),
        .HEX6(HEX6), .HEX5(HEX5), .HEX4(HEX4), 
        .HEX3(HEX3), .HEX2(HEX2), .HEX1(HEX1), 
        .HEX0(HEX0),
        .LCD_ON(LCD_ON),
        .LCD_BLON(LCD_BLON),
        .LCD_RW(LCD_RW),
        .LCD_EN(LCD_EN),
        .LCD_RS(LCD_RS),
        .LCD_DATA(LCD_DATA)
    );

endmodule