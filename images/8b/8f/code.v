module top_module(
input	A,
input	B,
output	S,
output	carry
);assign	S=A^B;
assign	carry=A&B;endmodule