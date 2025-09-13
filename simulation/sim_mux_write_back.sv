module sim_mux_write_back();

    logic [2:0] write_back;
    logic [31:0] mem_data;
    logic [31:0] alu_data;
    logic [31:0] pc_plus_one;
    logic [17:0] input_sw;
    logic [31:0] rs_data;
    logic [31:0] mux_out;

    // Instancia o módulo a ser testado
    mux_write_back uut (
        .write_back(write_back),
        .mem_data(mem_data),
        .alu_data(alu_data),
        .pc_plus_one(pc_plus_one),
        .input_sw(input_sw),
        .rs_data(rs_data),
        .mux_out(mux_out)
    );

    initial begin
        // Inicializa os sinais
        mem_data     = 32'hAAAA_BBBB;
        alu_data     = 32'h1234_5678;
        pc_plus_one  = 32'h0000_0004;
        input_sw     = 18'b1111_0000_0000_0001_10;
        rs_data      = 32'hDEAD_BEEF;

        // Teste 1: mem_data
        write_back = 3'b000;
        #10;

        // Teste 2: alu_data
        write_back = 3'b001;
        #10;

        // Teste 3: pc_plus_one
        write_back = 3'b010;
        #10;

        // Teste 4: input_extended (a partir de input_sw)
        write_back = 3'b011;
        #10;

        // Teste 5: rs_data
        write_back = 3'b100;
        #10;

        // Parar simulação para análise via waveform
        $stop;
    end

endmodule
