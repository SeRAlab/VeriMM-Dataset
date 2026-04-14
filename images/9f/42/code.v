module mux2to1(A, B, SEL, Y);
input A, B, SEL;
output Y;
assign Y = SEL ? B : A;
endmodule