module branch_logic_unit(
	input logic alu_less,
	input logic alu_zero,
	input logic [2:0] branch_type,
	output logic branch
);
	parameter	BEQ = 3'b001,
				BNE = 3'b010,
				BLT = 3'b011,
				BGT = 3'b100,
				BLE = 3'b101,
				BGE = 3'b110;
	
	always_comb begin
		case (branch_type)
			BEQ: branch = alu_zero;
			BNE: branch = ~alu_zero;
			BLT: branch = alu_less;
			BGT: branch = ~alu_less & ~alu_zero;
			BLE: branch = alu_less | alu_zero;
			BGE: branch = ~alu_less | alu_zero;
			default: branch = 1'b0;
		endcase
	end
	
endmodule