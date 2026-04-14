module top_module(
  input clk,
  input rst,
  input [31:0] sorted_array,
  input [31:0] target,
  output reg [31:0] index
);parameter ARRAY_SIZE = 8;
  parameter LOG2_ARRAY_SIZE = 3;

  reg [31:0] left;
  reg [31:0] right;
  reg [LOG2_ARRAY_SIZE:0] depth;

  always @(posedge clk, posedge rst) begin
    if (rst) begin
      index <= -1;
      left <= 0;
      right <= ARRAY_SIZE - 1;
      depth <= 0;
    end else begin
      if (depth == LOG2_ARRAY_SIZE) begin
        if (sorted_array[left] == target) begin
          index <= left;
        end else if (sorted_array[right] == target) begin
          index <= right;
        end else begin
          index <= -1;
        end
      end else begin
        depth <= depth + 1;
        if (target < sorted_array[(left + right) / 2]) begin
          right <= (left + right) / 2 - 1;
        end else begin
          left <= (left + right) / 2 + 1;
        end
      end
    end
  end

endmodule