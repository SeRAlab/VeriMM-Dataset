module top_module(
  input clk,
  input reset,
  input [31:0] max_count,
  output reg [31:0] count
);always @(posedge clk)
    begin
      if (reset) // Reset counter to zero
        count <= 0;
      else if (count == max_count) // Reset counter to zero when max_count is reached
        count <= 0;
      else // Increment counter
        count <= count + 1;
    end

endmodule