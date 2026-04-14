module top_module(
  input clk,
  input reset,
  input [1:0] opcode,
  input [7:0] operand1,
  input [7:0] operand2,
  output reg [7:0] result,
  output reg overflow
);reg [15:0] temp; // temporary register for multiplication and division
  always @(posedge clk) begin
    if (reset) begin
      result <= 8'd0;
      overflow <= 1'b0;
    end else begin
      case (opcode)
        2'b00: begin // addition
          temp <= operand1 + operand2;
          if (temp > 8'd255) begin
            overflow <= 1'b1;
            result <= temp[7:0];
          end else begin
            overflow <= 1'b0;
            result <= temp[7:0];
          end
        end
        2'b01: begin // subtraction
          temp <= operand1 - operand2;
          if (temp < 0) begin
            overflow <= 1'b1;
            result <= temp[7:0];
          end else begin
            overflow <= 1'b0;
            result <= temp[7:0];
          end
        end
        2'b10: begin // multiplication
          temp <= operand1 * operand2;
          if (temp > 8'd255) begin
            overflow <= 1'b1;
            result <= temp[7:0];
          end else begin
            overflow <= 1'b0;
            result <= temp[7:0];
          end
        end
        2'b11: begin // division
          if (operand2 == 8'd0) begin
            overflow <= 1'b1;
            result <= 8'd0;
          end else begin
            temp <= operand1 / operand2;
            if (temp > 8'd255) begin
              overflow <= 1'b1;
              result <= temp[7:0];
            end else begin
              overflow <= 1'b0;
              result <= temp[7:0];
            end
          end
        end
      endcase
    end
  end

endmodule