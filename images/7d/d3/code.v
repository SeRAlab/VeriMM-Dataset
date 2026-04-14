module full_adder_16bit(A, B, CIN, SUM, COUT);
input [15:0] A, B;
input CIN;
output [15:0] SUM;
output COUT;

assign {COUT, SUM} = A + B + CIN;

endmodule