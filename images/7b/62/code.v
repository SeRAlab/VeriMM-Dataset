module top_module(
  input wire a,
  input wire b,
  input wire c,
  input wire d,
  input wire [1:0] sel,
  output wire y
);assign y = sel[1] & sel[0] ? d : sel[1] & ~sel[0] ? c : ~sel[1] & sel[0] ? b : a;

endmodule