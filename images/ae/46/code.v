module full_adder_1bit(A, B, CIN, SUM, COUT);
input A, B, CIN;
output SUM, COUT;

assign {COUT, SUM} = A + B + CIN;

endmodule