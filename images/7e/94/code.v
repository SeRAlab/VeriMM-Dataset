module top_module(
  input [3:0] D0,
  input [3:0] D1,
  input [3:0] D2,
  input [3:0] D3,
  input S0,
  input S1,
  output [3:0] Y
);wire [3:0] w1, w2, w3;
  
  assign w1 = S0 ? D3 : D2;
  assign w2 = S0 ? D1 : D0;
  assign w3 = S1 ? w1 : w2;
  
  assign Y = w3;

endmodule