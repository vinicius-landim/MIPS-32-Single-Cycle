module sim_bin_to_bcd();
    logic [18:0] bin;
    logic [3:0] hundred_thousands;
    logic [3:0] ten_thousands;
    logic [3:0] thousands;
    logic [3:0] hundreds;
    logic [3:0] tens;
    logic [3:0] units;

    bin_to_bcd dut(
        .bin(bin),
        .hundred_thousands(hundred_thousands),
        .ten_thousands(ten_thousands),
        .thousands(thousands),
        .hundreds(hundreds),
        .tens(tens),
        .units(units)
    );

    initial begin
        bin = 18'b0;

        #10
        bin = 18'd123456;

        #100
        $stop;
    end 

endmodule
