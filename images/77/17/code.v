module top_module(
  input clk, rst,
  input [1:0] op,
  input [7:0] a, b,
  output reg [7:0] result,
  output reg overflow, underflow, negative
);always @(posedge clk) begin
    if (rst) begin
      result <= 8'd0;
      overflow <= 1'b0;
      underflow <= 1'b0;
      negative <= 1'b0;
    end
    else begin
      case (op)
        2'b00: result <= a + b; // addition
        2'b01: result <= a - b; // subtraction
        2'b10: result <= a * b; // multiplication
        2'b11: begin // division
          if (b == 8'h00) begin
            result <= 8'h00;
            overflow <= 1'b0;
            underflow <= 1'b0;
            negative <= 1'b0;
          end
          else begin
            result <= a / b;
            if (result > 8'h7F) begin
              result <= 8'h7F;
              overflow <= 1'b1;
            end
            else if (result < 8'h80) begin
              result <= 8'h80;
              underflow <= 1'b1;
            end
            else begin
              overflow <= 1'b0;
              underflow <= 1'b0;
            end
          end
        end
        default: begin
          result <= 8'd0;
          overflow <= 1'b0;
          underflow <= 1'b0;
          negative <= 1'b0;
        end
      endcase

      negative <= (result[7] == 1'b1);
    end
  end

endmodule