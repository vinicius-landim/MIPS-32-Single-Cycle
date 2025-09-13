module mux_2to1(
	input logic [31:0] data1,
	input logic [31:0] data2,
	input logic flag,
	output logic [31:0] mux_out
);
	
	always_comb begin
		case (flag)
			1'b0: mux_out = data1;
			2'b1: mux_out = data2;
		endcase
	end

endmodule