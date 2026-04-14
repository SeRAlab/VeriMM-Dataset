module top_module(
  input clk_in,
  input rst,
  input [7:0] divisor,
  output reg clk_out
);reg [7:0] counter;

  always @(posedge clk_in or negedge rst) begin
    if (~rst) begin
      clk_out <= 0;
      counter <= 0;
    end
    else begin
      counter <= counter + 1;
      if (counter == divisor) begin
        clk_out <= ~clk_out;
        counter <= 0;
      end
    end
  end

endmodule