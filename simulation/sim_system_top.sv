module sim_system_top;
    logic clk;
    // , read_clk;
    logic reset, btn_io, io_stall_led;
    logic [15:0] switches;
    logic [6:0] HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0;

    system_top uut(
        .clk(clk),
        // .read_clk(read_clk),
        .reset(reset),
        .btn_io(btn_io),
        .io_stall_led(io_stall_led),
        .switches(switches),
        .HEX6(HEX6),
        .HEX5(HEX5),
        .HEX4(HEX4),
        .HEX3(HEX3),
        .HEX2(HEX2),
        .HEX1(HEX1),
        .HEX0(HEX0)
    );

    always begin
        #10 clk = ~clk;
    end

    // always begin
    //     #15 btn_io = ~btn_io;
    // end

    initial begin
        clk = 0;
        btn_io = 0;
        // read_clk = 0;
        reset = 1;
        switches = 20;
        #5 reset = 0; #1 btn_io = 1;
        #1 btn_io = 0;

    @(negedge clk);

    // Configura switches ANTES da próxima subida
    switches = 10; // valor para o IN
    #1 btn_io = 1;
    #1 btn_io = 0;
    // #1 btn_io = 1; #1 btn_io = 0;
    
    

    #1000 $stop;

    end

endmodule