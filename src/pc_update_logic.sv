module pc_update_logic(
	input logic [31:0] pc_current,
	input logic [31:0] reg1_data,
	input logic [25:0] inst_target,
	input logic [31:0] inst_offset,
	input logic jumpreg,
	input logic branch,
	input logic jump,
	output logic [31:0] pc_next    
);
	
	logic [31:0] pc_plus_1;
	logic [31:0] pc_branch;
	logic [31:0] pc_jr_or_pc1;
	logic [31:0] pc_branch_or_jr;
	logic [31:0] pc_jump_addr;

	assign pc_plus_1 = pc_current + 1;
	assign pc_branch = pc_current + 1 + inst_offset;
	assign pc_jump_addr = {pc_current[31:26], inst_target};

	// MUX para JR
	mux_2to1 mux_jr (
		.flag(jumpreg),
		.data1(pc_plus_1),
		.data2(reg1_data),
		.mux_out(pc_jr_or_pc1)
	);

	// MUX para BRANCH
	mux_2to1 mux_br (
		.flag(branch),
		.data1(pc_jr_or_pc1),
		.data2(pc_branch),
		.mux_out(pc_branch_or_jr)
	);

	// MUX para JUMP
	mux_2to1 mux_j (
		.flag(jump),
		.data1(pc_branch_or_jr),
		.data2(pc_jump_addr),
		.mux_out(pc_next)
	);

endmodule