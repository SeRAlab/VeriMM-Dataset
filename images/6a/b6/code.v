module full_adder (A, B, CIN, SUM, COUT);
input A;
input B;
input CIN;
output SUM;
output COUT;

assign {COUT, SUM} = A + B + CIN;

endmodule

module adder_4bit (A, B, CIN, SUM, COUT);
input [3:0] A;
input [3:0] B;
input CIN;
output [3:0] SUM;
output COUT;

wire C1, C2, C3;

full_adder fa0 (A[0], B[0], CIN, SUM[0], C1);
full_adder fa1 (A[1], B[1], C1, SUM[1], C2);
full_adder fa2 (A[2], B[2], C2, SUM[2], C3);
full_adder fa3 (A[3], B[3], C3, SUM[3], COUT);

endmodule