module top_module(
  input [1:0] op,
  input [7:0] num1,
  input [7:0] num2,
  output reg [7:0] result,
  output reg overflow
);always @*
    case (op)
      2'b00: // addition
        begin
          result = num1 + num2;
          overflow = (result > 8'hFF);
        end
      2'b01: // subtraction
        begin
          result = num1 - num2;
          overflow = (result < 0);
        end
      2'b10: // multiplication
        begin
          result = num1 * num2;
          overflow = (result > 8'hFF);
        end
      2'b11: // division
        begin
          if (num2 == 0) begin
            result = 8'hFF; // division by zero
            overflow = 1;
          end else begin
            result = num1 / num2;
            overflow = 0;
          end
        end
    endcase

endmodule