module top_module(
  input      din,
  input      clk,
  output reg dout
);always @(*)
    if (clk)
      dout <= din;

endmodule