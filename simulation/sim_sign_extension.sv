module sim_sign_extension();

    // Entradas e saídas
    logic [15:0] inst_imm;
    logic [31:0] inst_imm_extended;

    // Instancia o módulo de extensão de sinal
    sign_extension uut (
        .inst_imm(inst_imm),
        .inst_imm_extended(inst_imm_extended)
    );

    // Estímulos
    initial begin

        // Testa valor positivo (ex: 0x0004)
        inst_imm = 16'h0004;
        #1 

        // Testa valor negativo (ex: 0xFFFF = -1)
        inst_imm = 16'hFFFF;
        #1 

        // Testa valor negativo (ex: 0x8000 = -32768)
        inst_imm = 16'h8000;
        #1 
        // Testa valor positivo (ex: 0x7FFF = 32767)
        inst_imm = 16'h7FFF;
        #1 
        inst_imm = 16'h0000;
        #1 
        $stop;
    end

endmodule

