module mux_write_reg (
	input logic [1:0] regdst,
	input logic [4:0] inst_rt,
	input logic [4:0] inst_rd,
	input logic [4:0] reg31_addr,
	output logic [4:0] mux_out
);
	
	always_comb begin
		case (regdst)
			2'b01: mux_out = inst_rt;
			2'b10: mux_out = inst_rd;
			2'b11: mux_out = reg31_addr;
			default: mux_out = 5'b00000;
		endcase
	end
	
endmodule