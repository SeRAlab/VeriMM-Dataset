module parallel_to_serial(CLK, RST, LOAD, SHIFT_EN, DATA_IN, DATA_OUT);
input CLK, RST, LOAD, SHIFT_EN;
input [7:0] DATA_IN;
output DATA_OUT;
reg [7:0] shift_reg;
reg DATA_OUT;

always @(posedge CLK or posedge RST) begin
    if (RST)
        shift_reg <= 8'b0;
    else if (LOAD)
        shift_reg <= DATA_IN;
    else if (SHIFT_EN)
        shift_reg <= {1'b0, shift_reg[7:1]};
end

always @(posedge CLK or posedge RST) begin
    if (RST)
        DATA_OUT <= 0;
    else
        DATA_OUT <= shift_reg[0];
end

endmodule