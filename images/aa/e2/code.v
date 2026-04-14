module top_module(
  input rst_n,
  input clk,
  input start,
  input [7:0] a,
  input [7:0] b,
  output reg done,
  output reg [15:0] result
);reg [7:0] b_shifted;
  reg [15:0] result_reg;
  reg [3:0] i;

  always @(posedge clk) begin
    if (!rst_n) begin
      done <= 0;
      result_reg <= 0;
      i <= 0;
    end else begin
      if (start) begin
        // Initialize the result register
        result_reg <= 0;

        // Shift operand b left by i bits and add to result_reg if bit i of operand a is 1
        for (i = 0; i < 8; i = i + 1) begin
          if (a[i] == 1) begin
            b_shifted <= b << i;
            result_reg <= result_reg + b_shifted;
          end
        end

        // Output the result
        result <= result_reg;
        done <= 1;
      end else begin
        done <= 0;
      end
    end
  end

endmodule