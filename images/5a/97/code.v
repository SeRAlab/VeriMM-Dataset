module top_module(A1, A2, B1, B2, O);input   A1;
input   A2;
input   B1;
input   B2;
output  O;
nand g0(O, A1, A2, B1, B2);
endmodule