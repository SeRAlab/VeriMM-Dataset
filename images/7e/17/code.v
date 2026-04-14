module top_module(
  input clk,
  input rst,
  input [7:0] target,
  input [99:0] sorted_array,
  output reg [6:0] index
);reg [6:0] low = 0;
  reg [6:0] high = 99;
  reg [6:0] mid;

  always @(posedge clk) begin
    if (rst) begin
      low <= 0;
      high <= 99;
      index <= -1;
    end else begin
      mid <= (low + high) / 2;
      if (sorted_array[mid] == target) begin
        index <= mid;
      end else if (low >= high) begin
        index <= -1;
      end else if (sorted_array[mid] > target) begin
        high <= mid - 1;
      end else begin
        low <= mid + 1;
      end
    end
  end

endmodule