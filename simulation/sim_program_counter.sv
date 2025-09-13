module sim_program_counter();

	// Sinais de controle
	logic clk;
	logic reset;
	logic flag_halt;
	logic flag_jumpreg;
	logic flag_branch;
	logic flag_jump;

	// Dados da instrução
	logic [25:0] inst_target;       // para instrução tipo J (jump)
	logic [31:0] inst_offset;       // imediato estendido (para branch tipo I)
	logic [31:0] reg1_data;         // usado no JR (jump register)
	logic [31:0] pc_addr;           // saída do PC atual
	logic [31:0] pc_next_addr;      // endereço calculado (próximo PC)

	// Clock
	initial clk = 0;
	always #5 clk = ~clk; // clock com período de 10 unidades de tempo

	// Instanciação do módulo de lógica de atualização do PC
	pc_update_logic pc_update_logic(
		.pc_current(pc_addr),
		.reg1_data(reg1_data),
		.inst_target(inst_target),
		.inst_offset(inst_offset),
		.jumpreg(flag_jumpreg),
		.branch(flag_branch),
		.jump(flag_jump),
		.pc_next(pc_next_addr)
	);

	// Instanciação do registrador de PC
	program_counter program_counter(
		.clk(clk),
		.halt(flag_halt),
		.reset(reset),
		.pc_in(pc_next_addr),
		.pc_out(pc_addr)
	);

	// Estímulos
	initial begin
		// Inicializa os sinais
		reset = 1;
		flag_halt = 0;
		flag_jumpreg = 0;
		flag_branch = 0;
		flag_jump = 0;
		inst_target = 26'b0;
		inst_offset = 32'b0;
		reg1_data = 32'b0;

		// Espera um ciclo de clock com reset ativado
		#10;
		reset = 0;

		// Caso 1: incremento normal do PC (pc + 1)
		#10;

		// Caso 2: branch verdadeiro com offset = 4
		flag_branch = 1;
		inst_offset = 32'd4;
		#10;
		// Caso 3: jump (tipo J) com inst_target = 3
		flag_branch = 0;#10 //delay de 10s para verificar pc+1
		flag_jump = 1;
		inst_target = 26'd3;
		#10;

		// Caso 4: jump register (JR), destino = reg1_data
		flag_jump = 0;#10 
		flag_jumpreg = 1;
		reg1_data = 32'h0000_0010;
		#10;

		// Caso 5: halt ativo (PC deve manter valor)
		flag_jumpreg = 0; #10
		flag_halt = 1;
		inst_offset = 32'd8; // não deve ser usado
		#10;

		// Caso 6: halt desativado, PC volta a atualizar
		flag_halt = 0;
		#10;

		$stop;
	end

endmodule
