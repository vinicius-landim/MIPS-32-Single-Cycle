module sim_ALU_control;

    // Entradas
    logic [5:0] inst_funct;
    logic [2:0] ALUop;

    // Saídas
    logic [3:0] ALUoperation;
    logic jumpreg;

    // Instância do DUT
    ALU_control dut (
        .inst_funct(inst_funct),
        .ALUop(ALUop),
        .ALUoperation(ALUoperation),
        .jumpreg(jumpreg)
    );

    // Estímulos
    initial begin
        // Operações tipo I e diretas por ALUop
        ALUop = 3'b000; inst_funct = 6'bxxxxxx; #10;
        ALUop = 3'b001; inst_funct = 6'bxxxxxx; #10;
        ALUop = 3'b010; inst_funct = 6'bxxxxxx; #10;
        ALUop = 3'b011; inst_funct = 6'bxxxxxx; #10;
        ALUop = 3'b100; inst_funct = 6'bxxxxxx; #10;
        ALUop = 3'b101; inst_funct = 6'bxxxxxx; #10;

        // Operações tipo R com funct
        ALUop = 3'b111;

        inst_funct = 6'b000000; #10; // ADD
        inst_funct = 6'b000001; #10; // SUB
        inst_funct = 6'b000010; #10; // MULT
        inst_funct = 6'b000011; #10; // DIV
        inst_funct = 6'b000100; #10; // AND
        inst_funct = 6'b000101; #10; // OR
        inst_funct = 6'b000110; #10; // XOR
        inst_funct = 6'b000111; #10; // NOR
        inst_funct = 6'b001000; #10; // JR
        inst_funct = 6'b001001; #10; // SLL
        inst_funct = 6'b001010; #10; // SRL
        inst_funct = 6'b111111; #10; // Default case

        $stop;
    end

endmodule
