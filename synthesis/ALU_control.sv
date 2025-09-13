module ALU_control(
    input logic [5:0] inst_funct,
    input logic [2:0] ALUop,
    output logic [3:0] ALUoperation,

    output logic jumpreg
);

    always_comb begin
        // default
        jumpreg = 1'b0;
        ALUoperation = 4'b0000;

        unique case (ALUop)
            3'b000: ALUoperation = 4'b0000; // Soma
            3'b001: ALUoperation = 4'b0100; // AND
            3'b010: ALUoperation = 4'b0101; // OR
            3'b011: ALUoperation = 4'b0110; // XOR
            3'b100: ALUoperation = 4'b0001; // Subtração
            3'b101: ALUoperation = 4'b1010; // LUI (<< 16)
            3'b111: begin
                unique case (inst_funct)
                    6'b000000: ALUoperation = 4'b0000; // Soma
                    6'b000001: ALUoperation = 4'b0001; // Subtração
                    6'b000010: ALUoperation = 4'b0010; // Multiplicação
                    6'b000011: ALUoperation = 4'b0011; // Divisão
                    6'b000100: ALUoperation = 4'b0100; // AND
                    6'b000101: ALUoperation = 4'b0101; // OR
                    6'b000110: ALUoperation = 4'b0110; // XOR
                    6'b000111: ALUoperation = 4'b0111; // NOR
                    6'b001000: begin
                        ALUoperation = 4'b1111; // Jump Register
                        jumpreg = 1'b1;
                    end
                    6'b001001: ALUoperation = 4'b1000; // SLL
                    6'b001010: ALUoperation = 4'b1001; // SRL
                    default:   ALUoperation = 4'b0000;
                endcase
            end
            default: ALUoperation = 4'b0000;
        endcase
    end

endmodule
