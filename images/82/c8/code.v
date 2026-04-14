module full_adder (A, B, CIN, SUM, COUT);
input A;
input B;
input CIN;
output SUM;
output COUT;

assign {COUT, SUM} = A + B + CIN;

endmodule