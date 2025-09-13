module sim_mux_write_reg();

	logic [2:0] regdst;
	logic [4:0] inst_rt;
	logic [4:0] inst_rd;
	logic [4:0] reg31_addr;
	logic [4:0] mux_out;

	// Instancia o módulo
	mux_write_reg uut (
		.regdst(regdst),
		.inst_rt(inst_rt),
		.inst_rd(inst_rd),
		.reg31_addr(reg31_addr),
		.mux_out(mux_out)
	);

	initial begin
		// Inicializa os valores
		inst_rt = 5'd10;
		inst_rd = 5'd15;
		reg31_addr = 5'd31;

		// Teste 1: regdst = 001 → inst_rt
		regdst = 3'b001;
		#10;

		// Teste 2: regdst = 010 → inst_rd
		regdst = 3'b010;
		#10;

		// Teste 3: regdst = 011 → reg31_addr
		regdst = 3'b011;
		#10;

		// Teste 4: regdst = 111 → default
		regdst = 3'b000;
		#10;

		// Para a simulação para observação no waveform
		$stop;
	end

endmodule

