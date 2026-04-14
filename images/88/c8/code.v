module top_module(
  input [n-1:0] in,
  input clk,
  input reset,
  output reg out
);parameter n = 4; // number of input signals
parameter m = 1; // number of output signals

always @ (posedge clk) begin
  if (reset) begin
    out <= 0;
  end else begin
    out <= out + in;
  end
end

endmodule