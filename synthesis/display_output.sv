module display_output(
    input logic flag_out, flag_in, flag_negative,
    input logic [19:0] bin_value,
    output logic [0:6] HEX6,
    output logic [0:6] HEX5,
    output logic [0:6] HEX4,
    output logic [0:6] HEX3,
    output logic [0:6] HEX2,
    output logic [0:6] HEX1,
    output logic [0:6] HEX0
);
    logic [19:0] bin_value_abs;
    logic [3:0] hundred_thousands, ten_thousands, thousands;
    logic [3:0] hundreds, tens, units;

    always_comb begin
        if (flag_negative && flag_out) //complemento de dois apenas para out (em in, os switches são em módulo)
            bin_value_abs = (~bin_value) + 20'd1;
        else
            bin_value_abs = bin_value;
    end

    bin_to_bcd bcd_converter(
        .bin(bin_value_abs),
        .hundred_thousands(hundred_thousands),
        .ten_thousands(ten_thousands),
        .thousands(thousands),
        .hundreds(hundreds),
        .tens(tens),
        .units(units)
    );

    always_comb begin
        HEX6 = 7'b1111110;
        HEX5 = 7'b1111110;
        HEX4 = 7'b1111110;
        HEX3 = 7'b1111110;
        HEX2 = 7'b1111110;
        HEX1 = 7'b1111110;
        HEX0 = 7'b1111110;

        if (flag_out || flag_in) begin
            HEX6 = (flag_negative) ? 7'b1111110 : 7'b1111111; // Display "-" caso o número seja negativo
            HEX5 = bcd_to_7seg(hundred_thousands);
            HEX4 = bcd_to_7seg(ten_thousands);
            HEX3 = bcd_to_7seg(thousands);
            HEX2 = bcd_to_7seg(hundreds);
            HEX1 = bcd_to_7seg(tens);
            HEX0 = bcd_to_7seg(units);
        end
    end


    function logic [6:0] bcd_to_7seg(input logic [3:0] digit);
        case (digit)
            4'd0: bcd_to_7seg = 7'b0000001;
            4'd1: bcd_to_7seg = 7'b1001111;
            4'd2: bcd_to_7seg = 7'b0010010;
            4'd3: bcd_to_7seg = 7'b0000110;
            4'd4: bcd_to_7seg = 7'b1001100;
            4'd5: bcd_to_7seg = 7'b0100100;
            4'd6: bcd_to_7seg = 7'b0100000;
            4'd7: bcd_to_7seg = 7'b0001111;
            4'd8: bcd_to_7seg = 7'b0000000;
            4'd9: bcd_to_7seg = 7'b0000100;
            default: bcd_to_7seg = 7'b1111111;
        endcase
    endfunction

endmodule
