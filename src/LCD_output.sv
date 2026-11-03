module LCD_output(
    input logic clk,
    input logic clk_processor,
    input logic reset,
    input logic flag_olcd,
    input logic [31:0] msg_from_cpu,
    input logic [31:0] arg_from_cpu,
    output logic LCD_ON,
    output logic LCD_BLON,
    output logic LCD_RW,
    output logic LCD_EN,
    output logic LCD_RS,
    inout wire [7:0] LCD_DATA
);
    assign LCD_ON   = 1'b1;
    assign LCD_BLON = 1'b1;

    logic [31:0] lcd_msg, lcd_arg;

    always_ff @(posedge clk_processor or posedge reset) begin
        if (reset) begin
            lcd_msg <= 32'd0;
            lcd_arg <= 32'd0;
        end
        else if (flag_olcd) begin
            lcd_msg <= msg_from_cpu;
            lcd_arg <= arg_from_cpu;
        end
    end

    logic delayed_reset_n;

    Reset_Delay reset_delay(
        .iCLK(clk),
        .oRESET(delayed_reset_n)
    );

    LCD_Display lcd_controller(
        .iCLK_50MHZ(clk),
        .iRST_N(delayed_reset_n),
        .msg(lcd_msg),
        .arg(lcd_arg),
        .LCD_RS(LCD_RS),
        .LCD_E(LCD_EN),
        .LCD_RW(LCD_RW),
        .DATA_BUS(LCD_DATA)
    );

endmodule