module xnor_gate (
  input [3:0] a,
  input [3:0] b,
  output [3:0] out);assign out = ~(a ^ b);
endmodule