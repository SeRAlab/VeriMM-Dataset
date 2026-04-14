module top_module(
  input clk_in,
  input rst_n,
  input [7:0] divider,
  output reg clk_out
);parameter WIDTH = 8; // width of the counter
parameter DIV_MAX = 255; // maximum value of divider

reg [WIDTH-1:0] counter;

always @(posedge clk_in or negedge rst_n) begin
  if (~rst_n) begin
    counter <= 0;
    clk_out <= 0;
  end
  else begin
    counter <= counter + 1;
    if (counter == divider) begin
      clk_out <= ~clk_out;
      counter <= 0;
    end
  end
end

endmodule