module system_top(
    input logic clk, read_clk,
    input logic reset, btn_io,
    input logic [15:0] switches,
    input logic sw_negative,
    output logic input_led, output_led, halt_led,
    output logic [6:0] HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0,
    output logic [17:0] data_led 
);
    logic [31:0] data_out;
    logic [19:0] bin_value_mux;
    logic flag_in, flag_out, flag_negative;
    logic btn_debounced;
    logic flag_io_negative;
    logic clk_processor;

    assign bin_value_mux = flag_in ? {4'b0, switches} : data_out[19:0]; //unsigned input
    assign flag_io_negative = flag_in ? sw_negative : flag_negative;

    assign data_led = bin_value_mux;

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
        .switches(switches),
        .sw_negative(sw_negative),
        .data_out(data_out),
        .flag_in(flag_in),
        .flag_out(flag_out),
        .flag_negative(flag_negative),
        .flag_halt(halt_led)
    );

    display_output display(
        .flag_out(flag_out),
        .flag_in(flag_in),
        .flag_negative(flag_io_negative),
        .bin_value(bin_value_mux),
        .HEX6(HEX6),
        .HEX5(HEX5),
        .HEX4(HEX4),
        .HEX3(HEX3),
        .HEX2(HEX2),
        .HEX1(HEX1),
        .HEX0(HEX0)
    );

    assign input_led = flag_in;
    assign output_led = flag_out;

endmodule