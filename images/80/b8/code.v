module top_module(
  input clk,
  input reset,
  input enable,
  output reg [3:0] count,
  output reg reached_max
);always @(posedge clk or negedge reset) begin
    if (reset == 0) begin
      count <= 4'b0;
      reached_max <= 0;
    end else if (enable == 1) begin
      if (count == 4'b1001) begin
        count <= 4'b0;
        reached_max <= 1;
      end else begin
        count <= count + 1;
        reached_max <= 0;
      end
    end
  end

endmodule