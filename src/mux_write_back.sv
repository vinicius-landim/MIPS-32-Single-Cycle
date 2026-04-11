module mux_write_back (
    input logic [2:0] write_back,
    input logic [31:0] mem_data,
    input logic [31:0] alu_data,
    input logic [31:0] pc_plus_one,
    input logic [31:0] input_data, 
    input logic [31:0] rs_data,
    output logic [31:0] mux_out
);

    always_comb begin
        case (write_back)
            3'b000: mux_out = mem_data;
            3'b001: mux_out = alu_data;
            3'b010: mux_out = pc_plus_one;
            3'b011: mux_out = input_data;
            3'b100: mux_out = rs_data;
			default: mux_out = 32'b0;
        endcase
    end
	
endmodule