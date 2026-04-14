module adder_4bit (A, B, CIN, SUM, COUT);
input [3:0] A, B;
input CIN;
output [3:0] SUM;
output COUT;

assign {COUT, SUM} = A + B + CIN;

endmodule