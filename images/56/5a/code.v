module top_module(A,B,C,D,F);input A,B,C,D;
output F;

wire w1,w2;

assign w1 = A|B;
assign w2 = C|D;
assign F = w1 & w2;

endmodule