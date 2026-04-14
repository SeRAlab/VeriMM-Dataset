module top_module(
  input clk,
  input reset,
  input [3:0] num1,
  input [3:0] num2,
  input cin,
  output reg [3:0] sum,
  output reg cout
);reg [3:0] p_sum1, p_sum2, p_sum3;
  reg p_cout1, p_cout2;

  always @(posedge clk) begin
    if (reset) begin
      p_sum1 <= 4'b0;
      p_sum2 <= 4'b0;
      p_sum3 <= 4'b0;
      p_cout1 <= 1'b0;
      p_cout2 <= 1'b0;
      sum <= 4'b0;
      cout <= 1'b0;
    end else begin
      p_sum1 <= num1 + num2;
      p_cout1 <= p_sum1[4];
      p_sum2 <= {p_sum1[3], p_sum1[2], p_sum1[1], p_sum1[0]} + {4'b1, cin};
      p_cout2 <= p_sum2[4];
      p_sum3 <= {p_sum2[3], p_sum2[2], p_sum2[1], p_sum2[0]};
      sum <= p_sum3;
      cout <= p_cout1 | (p_cout2 & ~p_cout1);
    end
  end

endmodule