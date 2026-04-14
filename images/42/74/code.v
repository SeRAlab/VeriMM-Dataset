module top_module(A, B, S, Y);input A, B, S;
output Y;
assign Y = S ? B : A;
endmodule