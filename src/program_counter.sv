module program_counter(
	input logic clk,
	input logic halt,
	input logic reset,
	input logic clk_manual,
	input logic io_stall,
	input logic flag_endp,
	input logic [31:0] kernel_pc,
	input logic [31:0] pc_in,
	output logic [31:0] pc_out
);
	logic clk_processor;
	
	assign clk_processor = io_stall ? clk_manual : clk;

	always_ff @(posedge clk_processor or posedge reset) begin
		if (reset)
			pc_out <= 32'b0;
		else if (~halt)
			if(flag_endp)
				pc_out <= kernel_pc;
			else
				pc_out <= pc_in;
	end

endmodule