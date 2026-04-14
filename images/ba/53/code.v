module top_module(
  input clk,
  input [4:0] a,
  input [4:0] b,
  input [4:0] c,
  output reg [1:0] out
);always @(posedge clk) begin
  if (a >= b && a >= c)
    out <= 2'b00;
  else if (b >= a && b >= c)
    out <= 2'b01;
  else if (c >= a && c >= b)
    out <= 2'b10;
  else
    out <= 2'b11;
end

endmodule