module top_module(A, B, C, D, S, T, Y);input A, B, C, D, S, T;
output Y;
assign Y = T ? (S ? D : C) :
               (S ? B : A);
endmodule