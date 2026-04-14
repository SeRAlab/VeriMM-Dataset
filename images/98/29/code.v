module mux_2to1 (A, B, S, Y);
input A, B;
input S;
output Y;

assign Y = S ? B : A;

endmodule