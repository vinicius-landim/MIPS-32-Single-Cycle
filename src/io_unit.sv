module io_unit(
    input logic clk,
    input logic clk_processor,
    input logic reset,
    input logic flag_in,
    input logic flag_out,
    input logic flag_olcd,
    input logic [31:0] data_from_cpu,
    output logic [31:0] data_to_cpu,
    input logic [15:0] switches_in,
    input logic sw_negative_in,
    output logic [6:0] HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0,
    output logic LCD_ON, LCD_BLON, LCD_RW, LCD_EN, LCD_RS,
    inout wire [7:0] LCD_DATA
);
    logic [31:0] switches_32b;
    logic [31:0] reg_out_data;
    
    assign switches_32b = {16'b0, switches_in};
    assign data_to_cpu = sw_negative_in ? (~switches_32b + 32'd1) : switches_32b;
  
    always_ff @(posedge clk_processor or posedge reset) begin
        if (reset)
            reg_out_data <= 32'b0;
        else if (flag_out)
            reg_out_data <= data_from_cpu;
    end

    logic [19:0] display_value_abs;
    logic display_is_negative;

    always_comb begin
        if (flag_in) begin
            display_is_negative = sw_negative_in;
            display_value_abs = {4'b0, switches_in};
        end
        else begin
            display_is_negative = reg_out_data[31];
            if (reg_out_data[31])
                display_value_abs = (~reg_out_data[19:0]) + 20'd1;
            else
                display_value_abs = reg_out_data[19:0];
        end
    end

    logic [3:0] hundred_thousands, ten_thousands, thousands, hundreds, tens, units;

    bin_to_bcd bcd_converter(
        .bin(display_value_abs),
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

        if(flag_out || flag_in) begin
            HEX6 = (display_is_negative) ? 7'b1111110 : 7'b1111111; 
            HEX5 = bcd_to_7seg(hundred_thousands);
            HEX4 = bcd_to_7seg(ten_thousands);
            HEX3 = bcd_to_7seg(thousands);
            HEX2 = bcd_to_7seg(hundreds);
            HEX1 = bcd_to_7seg(tens);
            HEX0 = bcd_to_7seg(units);
        end
    end

    logic [31:0] reg_lcd_data;

    //luzes sempre ligadas
    assign LCD_ON = 1'b1;
    assign LCD_BLON = 1'b1;

    always_ff @(posedge clk_processor or posedge reset) begin
        if (reset)
            reg_lcd_data <= 32'b0;
        else if (flag_olcd)
            reg_lcd_data <= data_from_cpu;
    end

    logic dly_rst;
    Reset_Delay r0(
        .iCLK(clk),
        .oRESET(dly_rst)
    );

    LCD_Display lcd_ctrl(
        .iCLK_50MHZ(clk),
        .iRST_N(dly_rst),
        .hex7(reg_lcd_data[31:28]),
        .hex6(reg_lcd_data[27:24]),
        .hex5(reg_lcd_data[23:20]),
        .hex4(reg_lcd_data[19:16]),
        .hex3(reg_lcd_data[15:12]),
        .hex2(reg_lcd_data[11:8]),
        .hex1(reg_lcd_data[7:4]),
        .hex0(reg_lcd_data[3:0]),
        .DATA_BUS(LCD_DATA),
        .LCD_RW(LCD_RW),
        .LCD_E(LCD_EN),
        .LCD_RS(LCD_RS)
    );

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