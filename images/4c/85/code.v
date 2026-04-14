module top_module( A, B, Ci, S, Co );input [3:0] A;
  input [3:0] B;
  input Ci;
  output [3:0] S;
  output Co;
  
  wire [3:0] temp;
  wire carry;

  assign {Co, S} = A + B + Ci; // Simple 4-bit adder with carry-in
endmodule