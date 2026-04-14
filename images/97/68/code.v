module top_module(
  input clk,
  input reset,
  input [1:0] op,
  input [7:0] num1,
  input [7:0] num2,
  output reg [7:0] result,
  output reg overflow,
  output reg zero
);always @(posedge clk) begin
    if (reset) begin
      result <= 0;
      overflow <= 0;
      zero <= 0;
    end
    else begin
      case (op)
        2'b00: begin // addition
          result <= num1 + num2;
          overflow <= (result > 8'hFF);
          zero <= (result == 0);
        end
        2'b01: begin // subtraction
          result <= num1 - num2;
          overflow <= (result < 0);
          zero <= (result == 0);
        end
        2'b10: begin // multiplication
          result <= num1 * num2;
          overflow <= (result > 8'hFF);
          zero <= (result == 0);
        end
        2'b11: begin // division
          if (num2 == 0) begin
            result <= 8'hFF;
            overflow <= 1;
            zero <= 0;
          end
          else begin
            result <= num1 / num2;
            overflow <= 0;
            zero <= (result == 0);
          end
        end
      endcase
    end
  end

endmodule