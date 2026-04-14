module top_module(
  input a,
  input b,
  input ci,
  output reg sum,
  output reg co
);assign sum = a ^ b ^ ci;
  assign co = (a & b) | (a & ci) | (b & ci);

endmodule