module top_module(
  input clk,
  input reset,
  input [7:0] in,
  input load,
  input clear,
  output reg [15:0] out
);always @(posedge clk) begin
    if (reset) begin
      out <= 0;
    end else if (clear) begin
      out <= 0;
    end else if (load) begin
      out <= out + in;
    end
  end

endmodule