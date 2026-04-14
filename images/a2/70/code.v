module mux_2to1(A, B, SEL, Y);
input A, B;
input SEL;
output Y;

assign Y = (SEL == 1'b0) ? A : B;

endmodule