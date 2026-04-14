module top_module(IN1,IN2,IN3,IN4,QN);input IN1;
input IN2,IN3,IN4;
output QN;

wire not1, not2, not3, not4, and1, and2, and3, nand1, nand2;

not U1 (not1, IN1);
not U2 (not2, IN2);
not U3 (not3, IN3);
not U4 (not4, IN4);

and A1 (and1, IN1, IN2);
and A2 (and2, IN3, IN4);
and A3 (and3, not1, not2, not3, not4);

nand N1 (nand1, and1, and2);
nand N2 (nand2, nand1, and3);

not U5 (QN, nand2);

endmodule