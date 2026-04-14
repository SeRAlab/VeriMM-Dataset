module top_module(
  input clk,
  input reset,
  input [7:0] a,
  input [7:0] b,
  input add,
  input sub,
  input mul,
  input div,
  output reg [15:0] c
);always @(posedge clk, negedge reset) begin
    if (reset == 0) begin
      c <= 0;
    end else begin
      if (add) begin
        c <= a + b;
      end else if (sub) begin
        c <= a - b;
      end else if (mul) begin
        c <= a * b;
      end else if (div) begin
        c <= a / b;
      end
    end
  end

endmodule