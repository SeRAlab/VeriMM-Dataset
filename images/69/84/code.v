module top_module(
  input a,
  input b,
  input clk,
  output reg out
);reg a_ff, b_ff;
  wire xor1, xor2;

  always @(posedge clk) begin
    a_ff <= a;
    b_ff <= b;
  end

  assign xor1 = a_ff ^ b_ff;
  assign xor2 = a ^ b;

  always @(posedge clk) begin
    out <= xor1 ^ xor2;
  end

endmodule