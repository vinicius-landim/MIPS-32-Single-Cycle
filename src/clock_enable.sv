// Slow clock enable for debouncing button 
module clock_enable(
    input logic clk_50MHz,
    output logic slow_clk_en
);
    logic [25:0]   counter=0;
    always_ff @(posedge clk_50MHz) begin
        counter <= (counter>=124999)?0:counter+1;
    end
    assign slow_clk_en = (counter == 124999)?1'b1:1'b0;
endmodule