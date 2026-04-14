module mux4bit2to1(A, B, SEL, Y);
input [3:0] A, B;
input SEL;
output [3:0] Y;
assign Y = SEL ? B : A;
endmodule