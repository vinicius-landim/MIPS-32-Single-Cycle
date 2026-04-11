module register_file(
	input logic clk,
	input logic regwrite,
	input logic[4:0] reg1_addr,
	input logic [4:0] reg2_addr,
	input logic [4:0] write_reg_addr,
	input logic [31:0] write_data,
	
	output logic [31:0] reg2_data,
	output logic [31:0] reg1_data
);

	logic [31:0] registers [31:0];

	// Escrita síncrona
	always_ff @(posedge clk) begin
		if (regwrite && write_reg_addr != 0) begin
			registers[write_reg_addr] <= write_data;
		end
	end

	// Leitura combinacional
	assign reg1_data = (reg1_addr != 0) ? registers[reg1_addr] : 32'b0;
	assign reg2_data = (reg2_addr != 0) ? registers[reg2_addr] : 32'b0;

endmodule
