module top_module(clk, rst, a, b, sub, result);input clk, rst, sub;
  input [3:0] a, b;
  output reg [3:0] result;
  
  always @(posedge clk) begin
    if (rst) begin
      result <= 4'b0000;
    end else begin
      if (sub) begin
        result <= a - b;
      end else begin
        result <= a + b;
      end
    end
  end
endmodule