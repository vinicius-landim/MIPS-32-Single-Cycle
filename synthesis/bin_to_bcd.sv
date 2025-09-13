module bin_to_bcd (
    input logic [19:0] bin,
    output logic [3:0] hundred_thousands,
    output logic [3:0] ten_thousands,
    output logic [3:0] thousands,
    output logic [3:0] hundreds,
    output logic [3:0] tens,
    output logic [3:0] units
);
    integer i;
    always_comb begin
        hundred_thousands = 4'd0;
        ten_thousands = 4'd0;
        thousands = 4'd0;
        hundreds = 4'd0;
        tens = 4'd0;
        units = 4'd0;

        //Double Dabble Algorithm
        for(i=19; i>=0; i=i-1) begin
            if(hundred_thousands >= 5)
                hundred_thousands = hundred_thousands + 4'd3;
            if(ten_thousands >= 5)
                ten_thousands = ten_thousands + 4'd3;
            if(thousands >= 5)
                thousands = thousands + 4'd3;
            if(hundreds >= 5)
                hundreds = hundreds + 4'd3;
            if(tens >= 5)
                tens = tens + 4'd3;
            if(units >= 5)
                units = units + 4'd3;

            hundred_thousands = hundred_thousands << 1;
            hundred_thousands[0] = ten_thousands[3];
            ten_thousands = ten_thousands << 1;
            ten_thousands[0] = thousands[3];
            thousands = thousands << 1;
            thousands[0] = hundreds[3];
            hundreds = hundreds << 1;
            hundreds[0] = tens[3];
            tens = tens << 1;
            tens[0] = units[3];
            units = units << 1;
            units[0] = bin[i];
        end
    end

endmodule