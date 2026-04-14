module	operator_C(
input	P,G,G1,
output	Go
);
assign	Go=G|(P&G1);
endmodule