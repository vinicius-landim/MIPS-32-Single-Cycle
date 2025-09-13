module sign_extension(
	input logic [15:0] inst_imm,
	output logic [31:0] inst_imm_extended
);
	assign inst_imm_extended = {{16{inst_imm[15]}}, inst_imm};	
endmodule