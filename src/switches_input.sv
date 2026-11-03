module switches_input(
    input logic [15:0] switches,
    input logic sw_negative,
    output logic [31:0] data_to_cpu
);
    logic [31:0] switches_32b;

    assign switches_32b = {16'b0, switches};
    assign data_to_cpu = sw_negative ? (~switches_32b + 32'd1) : switches_32b;

endmodule