module top_module(
  input clk,
  input reset,
  input enable,
  input [7:0] max_count,
  output reg [7:0] count
);always @(posedge clk) begin
    if (reset) begin
      count <= 0;
    end else if (enable && count == max_count) begin
      count <= 0;
    end else if (enable) begin
      count <= count + 1;
    end
  end

endmodule