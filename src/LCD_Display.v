/*
 SW8 (GLOBAL RESET) resets LCD
ENTITY LCD_Display IS
-- Enter number of live Hex hardware data values to display
-- (do not count ASCII character constants)
    GENERIC(Num_Hex_Digits: Integer:= 2); 
-----------------------------------------------------------------------
-- LCD Displays 16 Characters on 2 lines
-- LCD_display string is an ASCII character string entered in hex for 
-- the two lines of the  LCD Display   (See ASCII to hex table below)
-- Edit LCD_Display_String entries above to modify display
-- Enter the ASCII character's 2 hex digit equivalent value
-- (see table below for ASCII hex values)
-- To display character assign ASCII value to LCD_display_string(x)
-- To skip a character use 8'h20" (ASCII space)
-- To dislay "live" hex values from hardware on LCD use the following: 
--   make array element for that character location 8'h0" & 4-bit field from Hex_Display_Data
--   state machine sees 8'h0" in high 4-bits & grabs the next lower 4-bits from Hex_Display_Data input
--   and performs 4-bit binary to ASCII conversion needed to print a hex digit
--   Num_Hex_Digits must be set to the count of hex data characters (ie. "00"s) in the display
--   Connect hardware bits to display to Hex_Display_Data input
-- To display less than 32 characters, terminate string with an entry of 8'hFE"
-- (fewer characters may slightly increase the LCD's data update rate)
------------------------------------------------------------------- 
--                        ASCII HEX TABLE
--  Hex                      Low Hex Digit
-- Value  0   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F
------\----------------------------------------------------------------
--H  2 |  SP  !   "   #   $   %   &   '   (   )   *   +   ,   -   .   /
--i  3 |  0   1   2   3   4   5   6   7   8   9   :   ;   <   =   >   ?
--g  4 |  @   A   B   C   D   E   F   G   H   I   J   K   L   M   N   O
--h  5 |  P   Q   R   S   T   U   V   W   X   Y   Z   [   \   ]   ^   _
--   6 |  `   a   b   c   d   e   f   g   h   i   j   k   l   m   n   o
--   7 |  p   q   r   s   t   u   v   w   x   y   z   {   |   }   ~ DEL
-----------------------------------------------------------------------
-- Example "A" is row 4 column 1, so hex value is 8'h41"
-- *see LCD Controller's Datasheet for other graphics characters available
*/

/*
 * LCD_Display - controlador do LCD 16x2 (HD44780) do DE2-115
 *
 * Instrucao: OLCD rs, rt
 *   msg [15:0] : codigo da mensagem (registrador rs)
 *   arg [31:0] : valor exibido no "##" (registrador rt)
 *
 * Mensagens predefinidas (msg):
 *   0         arg exibido em hexadecimal (modo depuracao)
 *   1         LCD_OS_START
 *   2         LCD_OS_MENU
 *   3         LCD_OS_SINGLE_TASKING
 *   4         LCD_OS_MULTI_TASKING
 *   5         LCD_OS_ERROR
 *   6         LCD_OS_SELECT_PROC
 *   outro     igual ao 0
 *
 * Nos textos, "##" marca onde arg aparece em decimal (0 a 99).
 * Zero a esquerda vira espaco; valores > 99 aparecem como "**".
 */

/*
 * LCD_Display - controlador do LCD 16x2 (HD44780) do DE2-115
 *
 * Instrucao: OLCD rs, rt
 *   msg [31:0] : codigo da mensagem (registrador rs)
 *   arg [31:0] : valor exibido no "##" (registrador rt)
 *
 * Mensagens predefinidas (msg):
 *   1         LCD_OS_START
 *   2         LCD_OS_MENU
 *   3         LCD_OS_SINGLE_TASKING
 *   4         LCD_OS_MULTI_TASKING
 *   5         LCD_OS_ERROR
 *   6         LCD_OS_SELECT_PROC
 *   outro     display em branco
 *
 * Nos textos, "##" marca onde arg aparece em decimal (0 a 99).
 * Zero a esquerda vira espaco; valores > 99 aparecem como "**".
 */

module LCD_Display (
    iCLK_50MHZ,
    iRST_N,
    msg,
    arg,
    LCD_RS,
    LCD_E,
    LCD_RW,
    DATA_BUS
);

    input iCLK_50MHZ;
    input iRST_N;
    input [31:0] msg;
    input [31:0] arg;

    output LCD_RS;
    output LCD_E;
    output LCD_RW;

    inout [7:0] DATA_BUS;

    // Estados
    parameter
        HOLD          = 4'h0,
        FUNC_SET      = 4'h1,
        DISPLAY_ON    = 4'h2,
        MODE_SET      = 4'h3,
        Print_String  = 4'h4,
        LINE2         = 4'h5,
        RETURN_HOME   = 4'h6,
        DROP_LCD_E    = 4'h7,
        RESET1        = 4'h8,
        RESET2        = 4'h9,
        RESET3        = 4'ha,
        DISPLAY_OFF   = 4'hb,
        DISPLAY_CLEAR = 4'hc;

    reg [3:0] state;
    reg [3:0] next_command;

    reg [7:0] DATA_BUS_VALUE;

    wire [7:0] Next_Char;

    reg [19:0] CLK_COUNT_400HZ;
    reg [4:0]  CHAR_COUNT;

    reg CLK_400HZ;
    reg LCD_RW_INT;
    reg LCD_E;
    reg LCD_RS;

    // BIDIRECTIONAL TRI STATE LCD DATA BUS
    assign DATA_BUS = (LCD_RW_INT ? 8'bZZZZZZZZ : DATA_BUS_VALUE);

    LCD_display_string u1 (
        .index(CHAR_COUNT),
        .msg(msg),
        .arg(arg),
        .out(Next_Char)
    );

    assign LCD_RW = LCD_RW_INT;

    always @(posedge iCLK_50MHZ or negedge iRST_N) begin
        if (!iRST_N) begin
            CLK_COUNT_400HZ <= 20'h00000;
            CLK_400HZ       <= 1'b0;
        end
        else if (CLK_COUNT_400HZ < 20'h0F424) begin
            CLK_COUNT_400HZ <= CLK_COUNT_400HZ + 1'b1;
        end
        else begin
            CLK_COUNT_400HZ <= 20'h00000;
            CLK_400HZ       <= ~CLK_400HZ;
        end
    end

    // State Machine to send commands and data to LCD DISPLAY
    always @(posedge CLK_400HZ or negedge iRST_N) begin
        if (!iRST_N) begin
            state <= RESET1;
        end
        else begin
            case (state)

                RESET1:
                    begin
                        LCD_E          <= 1'b1;
                        LCD_RS         <= 1'b0;
                        LCD_RW_INT     <= 1'b0;
                        DATA_BUS_VALUE <= 8'h38;
                        state          <= DROP_LCD_E;
                        next_command   <= RESET2;
                        CHAR_COUNT     <= 5'b00000;
                    end

                RESET2:
                    begin
                        LCD_E          <= 1'b1;
                        LCD_RS         <= 1'b0;
                        LCD_RW_INT     <= 1'b0;
                        DATA_BUS_VALUE <= 8'h38;
                        state          <= DROP_LCD_E;
                        next_command   <= RESET3;
                    end

                RESET3:
                    begin
                        LCD_E          <= 1'b1;
                        LCD_RS         <= 1'b0;
                        LCD_RW_INT     <= 1'b0;
                        DATA_BUS_VALUE <= 8'h38;
                        state          <= DROP_LCD_E;
                        next_command   <= FUNC_SET;
                    end

                FUNC_SET:
                    begin
                        LCD_E          <= 1'b1;
                        LCD_RS         <= 1'b0;
                        LCD_RW_INT     <= 1'b0;
                        DATA_BUS_VALUE <= 8'h38;
                        state          <= DROP_LCD_E;
                        next_command   <= DISPLAY_OFF;
                    end

                DISPLAY_OFF:
                    begin
                        LCD_E          <= 1'b1;
                        LCD_RS         <= 1'b0;
                        LCD_RW_INT     <= 1'b0;
                        DATA_BUS_VALUE <= 8'h08;
                        state          <= DROP_LCD_E;
                        next_command   <= DISPLAY_CLEAR;
                    end

                DISPLAY_CLEAR:
                    begin
                        LCD_E          <= 1'b1;
                        LCD_RS         <= 1'b0;
                        LCD_RW_INT     <= 1'b0;
                        DATA_BUS_VALUE <= 8'h01;
                        state          <= DROP_LCD_E;
                        next_command   <= DISPLAY_ON;
                    end

                DISPLAY_ON:
                    begin
                        LCD_E          <= 1'b1;
                        LCD_RS         <= 1'b0;
                        LCD_RW_INT     <= 1'b0;
                        DATA_BUS_VALUE <= 8'h0C;
                        state          <= DROP_LCD_E;
                        next_command   <= MODE_SET;
                    end

                MODE_SET:
                    begin
                        LCD_E          <= 1'b1;
                        LCD_RS         <= 1'b0;
                        LCD_RW_INT     <= 1'b0;
                        DATA_BUS_VALUE <= 8'h06;
                        state          <= DROP_LCD_E;
                        next_command   <= Print_String;
                    end

                Print_String:
                    begin
                        state      <= DROP_LCD_E;
                        LCD_E      <= 1'b1;
                        LCD_RS     <= 1'b1;
                        LCD_RW_INT <= 1'b0;

                        // Next_Char ja vem em ASCII
                        DATA_BUS_VALUE <= Next_Char;

                        if ((CHAR_COUNT < 31) && (Next_Char != 8'hFE))
                            CHAR_COUNT <= CHAR_COUNT + 1'b1;
                        else
                            CHAR_COUNT <= 5'b00000;

                        if (CHAR_COUNT == 15)
                            next_command <= LINE2;
                        else if ((CHAR_COUNT == 31) || (Next_Char == 8'hFE))
                            next_command <= RETURN_HOME;
                        else
                            next_command <= Print_String;
                    end

                LINE2:
                    begin
                        LCD_E          <= 1'b1;
                        LCD_RS         <= 1'b0;
                        LCD_RW_INT     <= 1'b0;
                        DATA_BUS_VALUE <= 8'hC0;
                        state          <= DROP_LCD_E;
                        next_command   <= Print_String;
                    end

                RETURN_HOME:
                    begin
                        LCD_E          <= 1'b1;
                        LCD_RS         <= 1'b0;
                        LCD_RW_INT     <= 1'b0;
                        DATA_BUS_VALUE <= 8'h80;
                        state          <= DROP_LCD_E;
                        next_command   <= Print_String;
                    end

                DROP_LCD_E:
                    begin
                        LCD_E <= 1'b0;
                        state <= HOLD;
                    end

                HOLD:
                    begin
                        state <= next_command;
                    end

            endcase
        end
    end

endmodule