module binary_adder(A, B, SUM, COUT);
input [3:0] A, B;
output [3:0] SUM;
output COUT;
assign {COUT, SUM} = A + B;
endmodule