/*
 * LCD_display_string - devolve o caractere da posicao 'index' do display
 *
 *   index  0..15 = linha 1
 *   index 16..31 = linha 2
 *
 * Cada mensagem e' um texto de 32 caracteres (linha 1 + linha 2).
 * Se a mensagem mostra um numero (show_value = 1), ele aparece sempre
 * nas cinco ultimas posicoes da linha 2 (index 27 a 31), alinhado
 * a direita. Zeros a esquerda viram espaco; acima de 99999 vira "*****".
 */
module LCD_display_string (
    index,
    msg,
    arg,
    out
);
 
    input  [4:0]  index;
    input  [31:0] msg;
    input  [31:0] arg;
    output [7:0]  out;
    reg    [7:0]  out;
 
    // Codigos das mensagens
    localparam LCD_START          = 32'd1,
               LCD_MENU           = 32'd2,
               LCD_SINGLE_TASKING = 32'd3,
               LCD_MULTI_TASKING  = 32'd4,
               LCD_ERROR          = 32'd5,
               LCD_SELECT_PROC    = 32'd6,
               LCD_PROC_FINISHED  = 32'd7,
               LCD_LIST_BEGIN     = 32'd8,
               LCD_LIST_PROGRAM   = 32'd9,
               LCD_LIST_END       = 32'd10,
               LCD_PROCS_MENU     = 32'd11,
               LCD_RENAME_NEWNAME = 32'd12,
               LCD_RENAME_SUCCESS = 32'd13,
               LCD_DELETE_SUCCESS = 32'd14;
 
    // ---------- arg em decimal ----------
    wire [3:0] ten_thousands_digit, thousands_digit, hundreds_digit;
    wire [3:0] tens_digit, units_digit;
 
    bin_to_bcd bcd_converter (
        .bin(arg[19:0]),
        .hundred_thousands(),
        .ten_thousands(ten_thousands_digit),
        .thousands(thousands_digit),
        .hundreds(hundreds_digit),
        .tens(tens_digit),
        .units(units_digit)
    );

    //digito aparece se ele ou algum digito a esquerda for diferente de 0
    wire show_ten_thousands = (ten_thousands_digit != 0);
    wire show_thousands     = show_ten_thousands || (thousands_digit != 0);
    wire show_hundreds      = show_thousands     || (hundreds_digit != 0);
    wire show_tens          = show_hundreds      || (tens_digit != 0);

    wire overflow = (arg > 32'd99999);
 
    // ---------- Tabela de mensagens ----------
    reg [255:0] message_text;  // 32 caracteres de 8 bits
    reg         show_value;    // 1 = mensagem mostra numero
 
    always @* begin
        show_value = 1'b0;
 
        case (msg)
            LCD_START:
                message_text = {"Bem-vindo ao SO!",
                                " Aperte o botao "};
                // message_text = {"     /)_/)      ",
                //                 "    (=^.^=) <3  "};
                                
            LCD_MENU:
                message_text = {"1-Exec  2-Multi ",
                                "3-Progs 4-Lista "};
 
            LCD_SINGLE_TASKING: begin    // arg = programa escolhido
                message_text = {"Executando      ",
                                "Processo:  #####"};
                show_value = 1'b1;
            end
 
            LCD_PROC_FINISHED: begin     // arg = programa encerrado
                message_text = {"Proc. encerrado ",
                                "ID:        #####"};
                show_value = 1'b1;
            end
 
            LCD_MULTI_TASKING: begin
                message_text = {"Multitarefa     ",
                                "Processo:  #####"};
                show_value = 1'b1;
            end
 
            LCD_ERROR: begin
                message_text = {"ERRO            ",
                                "Codigo:    #####"};
                show_value = 1'b1;
            end
 
            LCD_SELECT_PROC: begin
                message_text = {"Selecione proc. ",
                                "ID:             "};
            end

            LCD_LIST_BEGIN: begin
                message_text = {"Listando Procs  ",
                                "Aperte o botao  "};
            end
				
            LCD_LIST_PROGRAM: begin
                message_text = {"Programa no HD  ",
                                "ID:        #####"};
                show_value = 1'b1;
            end

            LCD_LIST_END: begin
                message_text = {"Fim da listagem ",
                                "Total:     #####"};
                show_value = 1'b1;
            end

            LCD_PROCS_MENU: begin
                message_text = {"1-Renomear      ",
                                "2-Deletar       "};
            end

            LCD_RENAME_NEWNAME: begin
                message_text = {"Insira o novo ID",
                                "Novo ID:   #####"};
                show_value = 1'b1;
            end

            LCD_RENAME_SUCCESS: begin
                message_text = {"Proc. renomeado.",
                                "Novo ID:   #####"};
                show_value = 1'b1;
            end
 
            LCD_DELETE_SUCCESS: begin
                message_text = {"Proc. deletado  ",
                                "ID:        #####"};
                show_value = 1'b1;
            end

            default:                // codigo desconhecido: em branco
                message_text = {"Desconhecido    ",
                                "                "};
        endcase
    end
 
    // ---------- Caractere da posicao 'index' ----------
    // O 1o caractere do texto fica nos bits mais altos (255..248),
    // o 2o em 247..240, e assim por diante.
    // "+: 8" pega 8 bits a partir do bit indicado.
    wire [7:0] text_char = message_text[8*(31 - index) +: 8];
 
    // Digito -> ASCII: "0" = 8'h30, entao o digito n vira {4'h3, n}
    always @* begin
        if (show_value && index >= 5'd27) begin
            if (overflow)
                out = "*";
            else begin
                case (index)
                    5'd27:   out = show_ten_thousands ? {4'h3, ten_thousands_digit} : " ";
                    5'd28:   out = show_thousands     ? {4'h3, thousands_digit}     : " ";
                    5'd29:   out = show_hundreds      ? {4'h3, hundreds_digit}      : " ";
                    5'd30:   out = show_tens          ? {4'h3, tens_digit}          : " ";
                    default: out = {4'h3, units_digit};   // 31: unidade sempre aparece
                endcase
            end
        end
        else begin
            out = text_char;
        end
    end
 
endmodule