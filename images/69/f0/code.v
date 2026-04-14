module full_adder_2bit(A, B, CIN, SUM, COUT);
input [1:0] A, B;
input CIN;
output [1:0] SUM;
output COUT;

assign {COUT, SUM} = A + B + CIN;

endmodule