module d_flip_flop (
  input clk,
  input reset,
  input [3:0] d,
  output reg [3:0] q);always @(posedge clk) begin
  if (reset)
    q <= 4'b0000;
  else
    q <= d;
end

endmodule