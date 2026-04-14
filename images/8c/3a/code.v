module top_module(A, B, C, D, Y);input A, B, C, D;
output Y;
assign Y = ~((A | B) & (C | D));
endmodule