module top_module(
    input A, B,
    output [15:0] Y
);assign Y[0] = ~(A | B);
assign Y[1] = ~(A | ~B);
assign Y[2] = ~(~A | B);
assign Y[3] = ~(~A & ~B);
assign Y[4] = ~(~A & B);
assign Y[5] = ~(A & ~B);
assign Y[6] = ~(A ^ B);
assign Y[7] = ~(~A | ~B);
assign Y[8] = ~(~A & B);
assign Y[9] = ~(A & ~B);
assign Y[10] = ~(A ^ B);
assign Y[11] = ~(A | ~B);
assign Y[12] = ~(~A & B);
assign Y[13] = ~(~A & ~B);
assign Y[14] = ~(~A | B);
assign Y[15] = ~(A & B);

endmodule