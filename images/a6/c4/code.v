module top_module(clk,reset,a,b);input clk,reset;
  output [3:0] a,b;
  reg [3:0] a,b;

  always @(posedge clk or posedge reset)
    if (reset) begin
      a <= #1 4'd5;
      b <= #1 4'd6;
    end else begin
      a <= #1 b;
      b <= #1 a;
    end
endmodule