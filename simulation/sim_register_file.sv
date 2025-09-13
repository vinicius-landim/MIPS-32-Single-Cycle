module sim_register_file();

    logic [4:0] reg1_addr, reg2_addr;
    logic [4:0] write_reg_addr;
    logic [31:0] write_data;
    logic [31:0] reg1_data, reg2_data;
    logic clk;
    logic regwrite;

    // Instância do módulo
    register_file uut (
        .reg1_addr(reg1_addr),
        .reg2_addr(reg2_addr),
        .write_reg_addr(write_reg_addr),
        .write_data(write_data),
        .reg1_data(reg1_data),
        .reg2_data(reg2_data),
        .clk(clk),
        .regwrite(regwrite)
    );

    // Geração do clock
    initial clk = 0;
    always #5 clk = ~clk;  // clock com período de 10 unidades de tempo

    // Sequência de testes
    initial begin
        // Inicializações
        regwrite = 0;
        write_reg_addr = 0;
        write_data = 0;
        reg1_addr = 0;
        reg2_addr = 0;

        // Aguarda 2 ciclos de clock
        #10;

        // Escrita no registrador 1
        regwrite = 1;
        write_reg_addr = 5'd1;
        write_data = 255;
        #10;  // espera o clock escrever

        // Escrita no registrador 2
        write_reg_addr = 5'd2;
        write_data = 2047;
        #10;

        // Tenta escrever no registrador zero (deve ser ignorado)
        write_reg_addr = 5'd0;
        write_data = 300;
        #10;

        // Desabilita escrita
        regwrite = 0;
        #10;

        // Leitura dos registradores 1 e 2
        reg1_addr = 5'd1;
        reg2_addr = 5'd2;
        #10;

        // Leitura do registrador zero (deve ser 0)
        reg1_addr = 5'd0;
        reg2_addr = 5'd0;
        #10;

        $finish;
    end

endmodule

