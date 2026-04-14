module top_module(clk, d, en, q);input clk, d, en;
  output reg q;

  // Clock gating circuit
  wire gated_clk;
  assign gated_clk = clk & en;

  always @(posedge gated_clk) begin
    q <= d;
  end
endmodule