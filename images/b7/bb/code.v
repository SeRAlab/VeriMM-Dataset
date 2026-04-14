module full_adder_32bit(A, B, CIN, SUM, COUT);
input [31:0] A, B;
input CIN;
output [31:0] SUM;
output COUT;

assign {COUT, SUM} = A + B + CIN;

endmodule