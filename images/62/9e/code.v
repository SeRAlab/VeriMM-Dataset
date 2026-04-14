module top_module(A, B, C, D, S0, S1, Y);input A;
input B;
input C;
input D;
input S0;
input S1;
output Y;

wire notS0;
wire notS1;
wire and1;
wire and2;
wire and3;
wire and4;

not #(1) U1(notS0, S0);
not #(1) U2(notS1, S1);
and #(1) U3(and1, A, notS1, notS0);
and #(1) U4(and2, B, notS1, S0);
and #(1) U5(and3, C, S1, notS0);
and #(1) U6(and4, D, S1, S0);
or #(1) U7(Y, and1, and2, and3, and4);

endmodule