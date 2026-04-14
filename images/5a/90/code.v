module top_module(Y,A, B, C, D);output Y;
input A, B, C, D;
assign Y = (~(A | D)) & (B & C & ~D);
endmodule