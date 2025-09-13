module sim_display_output();
    logic flag_out, flag_negative;
    logic [19:0] bin_value;
    logic [6:0] HEX6;
    logic [6:0] HEX5;
    logic [6:0] HEX4;
    logic [6:0] HEX3;
    logic [6:0] HEX2;
    logic [6:0] HEX1;
    logic [6:0] HEX0;

    display_output dut(
        .flag_out(flag_out),
        .flag_negative(flag_negative),
        .bin_value(bin_value),
        .HEX6(HEX6),
        .HEX5(HEX5),
        .HEX4(HEX4),
        .HEX3(HEX3),
        .HEX2(HEX2),
        .HEX1(HEX1),
        .HEX0(HEX0)
    );

    initial begin
        flag_out = 0;
        flag_negative = 0;
        bin_value = 20'b0;

        #10;
        bin_value = 20'd123456;
        flag_out = 1;

        #10;
        flag_out = 0;

        #10;
        bin_value = 20'd234234;
        flag_out = 1;
        #100;
    end
endmodule