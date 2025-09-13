module sim_data_RAM();
    logic [31:0] addr;
    logic [31:0] data;
    logic [31:0] mem_out;
    logic clk = 1;
    logic memwrite;
    logic memread;

    // Instancia o módulo
    data_RAM dut (
        .addr(addr),
        .data(data),
        .mem_out(mem_out),
        .clk(clk),
        .memwrite(memwrite),
        .memread(memread)
    );

    // Geração do clock
    
    always #5 clk = ~clk;

    initial begin
        // Inicialização
        clk = 0;
        addr = 0;
        data = 0;
        memwrite = 0;
        memread = 0;
        // Aguarda uma borda de clock
        #10;
        // Escrita: escreve em addr = 10 o valor DEADBEEF
        addr = 10;
        data = 32'hDEADBEEF;
        memwrite = 1;
        #10; // borda de clock
        memwrite = 0;

        // Leitura: lê de addr = 10
        memread = 1;
        #10;

        // Leitura de posição não escrita: addr = 20
        addr = 20;
        #10;

        // Desliga leitura
        memread = 0;
        #10;
        $stop;
    end

endmodule
