module hd_controller(
    input logic clk,
    input logic reset,
    input logic flag_hdaddr,
    input logic flag_hdwrite,
    input logic [31:0] reg1_data,
    input logic [31:0] reg2_data,
    output logic [9:0] track,
    output logic [9:0] sector,
    output logic [31:0] hd_in
);
    logic [9:0] write_track_reg, write_sector_reg;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            write_track_reg  <= 10'd0;
            write_sector_reg <= 10'd0;
        end
        else if (flag_hdaddr) begin
            write_track_reg  <= reg1_data[9:0];
            write_sector_reg <= reg2_data[9:0];
        end
    end

    assign track  = flag_hdwrite ? write_track_reg  : reg1_data[9:0];
    assign sector = flag_hdwrite ? write_sector_reg : reg2_data[9:0];
    assign hd_in  = reg1_data;
endmodule