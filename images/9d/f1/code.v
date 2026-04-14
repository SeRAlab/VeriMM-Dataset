module top_module(A, B, C, Cout);input [7:0] A, B;
   output [7:0] C;
   output Cout;
   wire [7:0] temp = A ^ B;
   wire [7:0] carry = A & B;
   assign C = temp ^ carry;
   assign Cout = carry << 1;
endmodule