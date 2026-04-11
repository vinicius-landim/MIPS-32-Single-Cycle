module data_RAM #(
	parameter ADDR_WIDTH=10
)(
	input logic [31:0] data,
	input logic [(ADDR_WIDTH-1):0] read_addr, write_addr,
	
	input read_clk, write_clk,
	input memwrite, memread,
	
	output logic [31:0] mem_out
);
	
	// Declare the RAM variable
	reg [31:0] ram[2**ADDR_WIDTH-1:0];
	
	always_ff @ (posedge write_clk) begin
		// Write
		if (memwrite)
			ram[write_addr] <= data;
	end
	
	always_ff @ (posedge read_clk) begin
		// Read 
		if(memread)
			mem_out <= ram[read_addr];
	end
	
endmodule