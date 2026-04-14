module top_module(clk, rst, a, b, cin, sum, cout);input clk, rst;
  input [3:0] a, b;
  input cin;
  output [3:0] sum;
  output cout;

  reg [3:0] sum_reg;
  reg cout_reg;

  always @(posedge clk) begin
    if (rst) begin
      sum_reg <= 4'b0;
      cout_reg <= 1'b0;
    end
    else begin
      sum_reg <= a + b + cin;
      cout_reg <= (a[3] & b[3]) | (a[3] & cin) | (b[3] & cin);
    end
  end

  assign sum = sum_reg;
  assign cout = cout_reg;

endmodule