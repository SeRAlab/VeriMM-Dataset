module top_module(
  input clk,
  input reset,
  input [3:0] binary,
  output reg [3:0] gray,
  output reg flag
);reg [3:0] prev_gray;

  always @(posedge clk, posedge reset) begin
    if (reset) begin
      gray <= 0;
      flag <= 0;
      prev_gray <= 0;
    end else begin
      gray <= binary ^ (binary >> 1);
      flag <= (gray != prev_gray);
      prev_gray <= gray;
    end
  end

endmodule