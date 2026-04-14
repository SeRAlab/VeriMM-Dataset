module top_module(
  input clk,
  input rst_n,
  input op,
  input signed [7:0] a,
  input signed [7:0] b,
  output reg signed [7:0] result,
  output reg overflow
);always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      result <= 0;
      overflow <= 0;
    end else begin
      if (op == 0) begin // addition
        result <= a + b;
        if (((a > 0) && (b > 0) && (result < 0)) || ((a < 0) && (b < 0) && (result > 0))) begin
          overflow <= 1;
        end else begin
          overflow <= 0;
        end
      end else begin // subtraction
        result <= a - b;
        if (((a > 0) && (b < 0) && (result < 0)) || ((a < 0) && (b > 0) && (result > 0))) begin
          overflow <= 1;
        end else begin
          overflow <= 0;
        end
      end
    end
  end

endmodule