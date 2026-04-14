module top_module(A1, A2, A3, A4, O);input   A1;
input   A2;
input   A3;
input   A4;
output  O;

wire n1, n2, n3, n4, n5;

nand g1(n1, A1, A1);
nand g2(n2, A2, A2);
nand g3(n3, A3, A3);
nand g4(n4, A4, A4);
nand g5(n5, n1, n2, n3, n4);
nand g6(O, n5, n5);

endmodule