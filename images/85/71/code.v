module top_module(
  input clk,
  input en,
  input te,
  input [31:0] d,
  output reg [31:0] q
);wire gated_clk;
  assign gated_clk = (en & te) ? clk : 1'b0;
  
  always @(posedge gated_clk) begin
    q <= d;
  end

endmodule