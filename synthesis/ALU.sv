module ALU(
	input logic [31:0] X, Y,
	input logic [4:0] shamt,
	input logic [3:0] op,
	output logic [31:0] alu_out,
	output logic zero,
	output logic less
);
	
	parameter 	ADD = 4'b0000,
				SUB = 4'b0001,
				MUL = 4'b0010,
				DIV = 4'b0011,
				AND = 4'b0100,
				OR = 4'b0101,
				XOR = 4'b0110,
				NOR = 4'b0111,
				SLL = 4'b1000,
				SRL = 4'b1001,
				LUI = 4'b1010;
	always_comb begin
		case(op)
			ADD: alu_out = X + Y;
			SUB: alu_out = X - Y;
			MUL: alu_out = X * Y;
			DIV: alu_out = X / Y;
			AND: alu_out = X & Y;
			OR: alu_out = X | Y;
			XOR: alu_out = X ^ Y;
			NOR: alu_out = ~(X | Y);
			SLL: alu_out = Y << shamt; 
			SRL: alu_out = Y >> shamt;
			LUI: alu_out = Y << 16;
			default: alu_out = 32'b0;
		endcase
		
	end
	
	assign less = alu_out[31];
	assign zero = (alu_out == 0);
	
endmodule