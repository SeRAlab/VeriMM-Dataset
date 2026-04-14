module top_module(
    input [9:0] I1,
    input [9:0] I2,
    output reg [9:0] S
);// Calculate the output using the given equation
always @*
    S = (I1 & 10'b1010101010) | (I2 & 10'b0101010101);

endmodule