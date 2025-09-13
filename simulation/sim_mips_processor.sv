module sim_mips_processor;

    logic clk, read_clk;
    logic reset_pc, flag_out, flag_negative;
    logic [15:0] switches;
    logic [31:0] data_out;

    // Instância do processador
    mips_processor dut (
        .clk(clk),
        .read_clk(read_clk),
        .reset_pc(reset_pc),
        .switches(switches),
        .data_out(data_out),
        .flag_out(flag_out),
        .flag_negative(flag_negative)
    );

    // Geração do clock: 10ns de período
    always begin
        #5 clk = ~clk;
    end

    always begin
        #0.5 read_clk = ~read_clk;
    end

    initial begin
    clk = 0;
    read_clk = 0;
    reset_pc = 1;
    switches = 0;
    #5 reset_pc = 0; // libera reset

    @(negedge clk);

    // Configura switches ANTES da próxima subida
    switches = 10; // valor para o IN

    @(negedge clk);
    // Nesse momento o valor 10 será escrito no registrador $1

    // Configura switches para a próxima entrada
    // switches = 1;

    @(posedge clk);
    // Novo valor 20 será escrito no registrador $2

    // Continue conforme necessário...

    #100 $stop;
end


endmodule
