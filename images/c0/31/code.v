module	operator_B(
input	P,G,P1,G1,
output	Po,Go
);
assign	Po=P&P1;
assign	Go=G|(P&G1);
endmodule