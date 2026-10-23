module hard_disk(
	input logic [(DATA_WIDTH-1):0] hd_in,
	input logic [9:0] track, sector, //definir quantos bits da instrução serão usados
	input logic read_clock, write_clock,
	input logic flag_hdread, flag_hdwrite,
	output logic [(DATA_WIDTH-1):0] hd_out
);
	parameter	DATA_WIDTH=32,
				TRACK_SIZE=32, 
				SECTOR_SIZE=1024,
				HD_SIZE = TRACK_SIZE * SECTOR_SIZE; 
	
	// Declare the RAM variable
	reg [DATA_WIDTH-1:0] hard_disk[HD_SIZE-1:0];
	
	initial begin
		hard_disk[0*SECTOR_SIZE+0] = 32'b001111_00001_00000_0000000000000000;
		hard_disk[0*SECTOR_SIZE+1] = 32'b001111_00010_00000_0000000000000000;
		hard_disk[0*SECTOR_SIZE+2] = 32'b010011_00000000000000000000000000;
		
	end
	always @ (posedge write_clock)
	begin
		// Write
		if (flag_hdwrite)
			hard_disk[track*SECTOR_SIZE+sector] <= hd_in;
	end
	
	always @ (posedge read_clock)
	begin
		// Read 
		if(flag_hdread)
			hd_out <= hard_disk[track*SECTOR_SIZE+sector];
	end
	
endmodule
