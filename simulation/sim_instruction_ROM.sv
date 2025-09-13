module sim_instruction_ROM;

// Parâmetros
    parameter ADDR_WIDTH = 8;

    // Sinais
    logic clk;
    logic [ADDR_WIDTH-1:0] addr;
    logic [31:0] inst_code;

    // Instância do módulo a ser testado
    instruction_ROM #(
        .init_file("rom_init.mif"),  // Certifique-se de criar esse arquivo
        .ADDR_WIDTH(ADDR_WIDTH)
        ) dut (
        .clk(clk),
        .addr(addr),
        .inst_code(inst_code)
    );

    // Geração de clock
    initial clk = 0;
    always #5 clk = ~clk;  // Clock com período de 10 ns

    // Estímulos
    initial begin
    // Inicia com addr = 0 e avança a cada ciclo de clock
    addr = 0;
        #10 addr = 1;
        #10 addr = 2;
        #10 addr = 3;
        #15;
    $stop;  // Para simulação, ideal para ver waveform
    end

endmodule
