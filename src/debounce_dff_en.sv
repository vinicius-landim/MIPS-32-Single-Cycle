    // D-flip-flop with clock enable signal for debouncing module 
module debounce_dff_en(
    input logic DFF_CLOCK, clock_enable, D, 
    output logic Q = 0
);
    always_ff @(posedge DFF_CLOCK) begin
        if(clock_enable == 1) 
            Q <= D;
    end
endmodule 