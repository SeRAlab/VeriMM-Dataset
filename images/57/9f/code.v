module mux_2to1_2bit (A, B, S, Y);
input [1:0] A, B;
input S;
output [1:0] Y;

assign Y = S ? B : A;

endmodule