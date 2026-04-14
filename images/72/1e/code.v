module top_module(
  input clk1,
  input clk2,
  input d1,
  input d2,
  input rst,
  output reg q
);always @(posedge clk1 or posedge clk2 or posedge rst) begin
    if (rst) begin
      q <= 0;
    end else if (clk1) begin
      q <= d1;
    end else if (clk2) begin
      q <= d2;
    end
  end

endmodule