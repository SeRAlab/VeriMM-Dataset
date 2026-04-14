module top_module(
  input clk,
  input rst,
  input [3:0] div_factor,
  output reg clk_out
);// The module has a 4-bit control input, which allows for division factors of up to 16.
// The default division factor is 2.
parameter DEFAULT_DIV_FACTOR = 2;
parameter MAX_DIV_FACTOR = 16;

initial begin
  clk_out <= 0;
end

reg [3:0] count;

always @(posedge clk or negedge rst) begin
  if (~rst) begin
    clk_out <= 0;
    count <= 0;
  end
  else begin
    if (count >= div_factor - 1) begin
      count <= 0;
      clk_out <= ~clk_out;
    end
    else begin
      count <= count + 1;
    end
  end
end

endmodule