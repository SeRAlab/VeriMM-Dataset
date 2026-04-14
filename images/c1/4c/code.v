module	operator_A(
input	A,
input	B,
output	P,
output	G
);
assign	P=A^B;
assign	G=A&B;
endmodule