module ALU_test();

    logic [31:0] X, Y;
    logic [4:0] shamt;
    logic [3:0] op;
    logic [31:0] alu_out;
    logic zero;
    logic less;

    // Instanciando a ALU
    ALU alu (
        .X(X),
        .Y(Y),
        .shamt(shamt),
        .op(op),
        .alu_out(alu_out),
        .zero(zero),
        .less(less)
    );

    initial begin
        // ADD
        X = 32'd10; Y = 32'd20; shamt = 0; op = 4'b0000; #10;

        // SUB
        X = 32'd15; Y = 32'd15; shamt = 0; op = 4'b0001; #10;

        // SUB & less
        X = 32'd15; Y = 32'd20; shamt = 0; op = 4'b0001; #10;

        // MULL
        X = 32'd5; Y = 32'd6; shamt = 0; op = 4'b0010; #10;

        // DIV
        X = 32'd100; Y = 32'd10; shamt = 0; op = 4'b0011; #10;

        // // AND
        // X = 32'b11100000000000000000000000000101; Y = 32'b00000000000000000000000000000011; shamt = 0; op = 4'b0100; #10;

        // // OR
        // X = 32'b11100000000000000000000000000101; Y = 32'b00000000000000000000000000000011; shamt = 0; op = 4'b0101; #10;

        // // XOR
        // X = 32'hFFFF0000; Y = 32'h00FFFF00; shamt = 0; op = 4'b0110; #10;

        // // NOR
        // X = 32'h0000000F; Y = 32'h000000F0; shamt = 0; op = 4'b0111; #10;

        // // SLL
        // Y = 32'h00000001; shamt = 4; op = 4'b1000; #10;

        // // SRL
        // Y = 32'h00000010; shamt = 2; op = 4'b1001; #10;

        // // LUI
        // Y = 32'h0000FFFF; shamt = 0; op = 4'b1010; #10;

        // Finaliza simulação
        $stop;
    end
endmodule
