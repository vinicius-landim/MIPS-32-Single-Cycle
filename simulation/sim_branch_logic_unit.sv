module sim_branch_logic_unit();
    logic alu_less;
    logic alu_zero;
    logic [2:0] branch_type;
    logic branch;

    // Instância da unidade de lógica de desvio
    branch_logic_unit uut (
        .alu_less(alu_less),
        .alu_zero(alu_zero),
        .branch_type(branch_type),
        .branch(branch)
    );

    // Ciclo de teste
    initial begin
        // BEQ: branch if equal (alu_zero == 1)
        branch_type = 3'b001;
        alu_less = 0; alu_zero = 0; #10;
        alu_less = 0; alu_zero = 1; #10;
        alu_less = 1; alu_zero = 0; #10;

        // BNE: branch if not equal (alu_zero == 0)
        branch_type = 3'b010;
        alu_less = 0; alu_zero = 0; #10;
        alu_less = 0; alu_zero = 1; #10;
        alu_less = 1; alu_zero = 0; #10;

        // BGT: branch if greater than (¬less & ¬zero)
        branch_type = 3'b011;
        alu_less = 0; alu_zero = 0; #10;
        alu_less = 0; alu_zero = 1; #10;
        alu_less = 1; alu_zero = 0; #10;

        // BLT: branch if less than (less == 1)
        branch_type = 3'b100;
        alu_less = 0; alu_zero = 0; #10;
        alu_less = 0; alu_zero = 1; #10;
        alu_less = 1; alu_zero = 0; #10;

        // BGE: branch if greater or equal (¬less)
        branch_type = 3'b101;
        alu_less = 0; alu_zero = 0; #10;
        alu_less = 0; alu_zero = 1; #10;
        alu_less = 1; alu_zero = 0; #10;

        // BLE: branch if less or equal (less | zero)
        branch_type = 3'b110;
        alu_less = 0; alu_zero = 0; #10;
        alu_less = 0; alu_zero = 1; #10;
        alu_less = 1; alu_zero = 0; #10;

        // DEFAULT (branch_type = 000, branch should be 0)
        branch_type = 3'b000;
        alu_less = 0; alu_zero = 0; #10;
        alu_less = 0; alu_zero = 1; #10;
        alu_less = 1; alu_zero = 0; #10;

        $stop;
    end
endmodule
