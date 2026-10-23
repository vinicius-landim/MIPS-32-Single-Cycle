module instruction_RAM #(
	parameter init_file = "rom_init.mif", 
	parameter ADDR_WIDTH=11
) (
	input [31:0] inst_in,
	input [ADDR_WIDTH-1:0] read_addr, write_addr,
	input flag_instwrite, read_clock, write_clock,
	output reg [31:0] inst_out
);

	logic [31:0] ram[2**ADDR_WIDTH-1:0];
	
	initial begin
		$readmemb(init_file, ram);
	end
	
	always @ (posedge write_clock)
	begin
		//write
		if (flag_instwrite)
			ram[write_addr] <= inst_in;
	end
	
	always @ (posedge read_clock)
	begin
		inst_out <= ram[read_addr];
	end
	
endmodule
