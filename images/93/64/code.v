module top_module(
  input clk,
  input rst,
  input [5-1:0] a,
  input [5-1:0] b,
  output reg [5-1:0] c
);always @(posedge clk) begin
    if(rst) begin
      c <= 0;
    end else begin
      if(a < b) begin
        c <= a;
      end else begin
        c <= b;
      end
    end
  end


endmodule