module adder_4bit(
  input [3:0] A,
  input [3:0] B,
  input CIN,
  output [3:0] S,
  output COUT
);

  assign {COUT, S} = A + B + CIN;
  
endmodule