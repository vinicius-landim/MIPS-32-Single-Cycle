module sim_button_pulse_synchronizer();
   // Sinais
    logic clk_sys;
    logic reset;
    logic level;
    logic pulse_out;

    // Instancia o DUT (Device Under Test)
    button_pulse_synchronizer dut (
        .clk_sys(clk_sys),
        .reset(reset),
        .level(level),
        .pulse_out(pulse_out)
    );

    // Clock do sistema: 10ns período (100 MHz)
    initial clk_sys = 0;
    always #5 clk_sys = ~clk_sys;

    // Sequência de estímulos
    initial begin
        // Inicializa sinais
        reset = 1;
        level = 0;

        // Reset
        #20;
        reset = 0;

        // Primeiro pulso rápido (botão aperta e solta rápido)
        #12; level = 1;
        #8;  level = 0;

        // Aguarda alguns ciclos
        #40;

        // Segundo pulso longo (botão apertado e segurado)
        #15; level = 1;
        #50; level = 0;

        // Terceiro pulso muito rápido (glitch)
        #30; level = 1;
        #5;  level = 0;

        // Fim da simulação
        #50;
        $stop;
    end

endmodule