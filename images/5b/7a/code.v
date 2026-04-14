module top_module(
  input [3:0] A,
  input [3:0] B,
  input [1:0] opcode,
  input clk,
  output reg [3:0] result
);reg [4:0] intermediate_result;
  reg overflow;
  reg divide_by_zero;

  always @(posedge clk) begin
    case (opcode)
      2'b00: begin // addition
        intermediate_result = A + B;
        overflow = (intermediate_result > 15);
        result = (overflow) ? 4'b1111 : intermediate_result[3:0];
      end
      2'b01: begin // subtraction
        intermediate_result = A - B;
        overflow = (intermediate_result < 0);
        result = (overflow) ? 4'b1111 : intermediate_result[3:0];
      end
      2'b10: begin // multiplication
        intermediate_result = A * B;
        overflow = (intermediate_result > 15);
        result = (overflow) ? 4'b1111 : intermediate_result[3:0];
      end
      2'b11: begin // division
        if (B == 0) begin
          divide_by_zero = 1;
          result = 4'b1111;
        end else begin
          divide_by_zero = 0;
          result = A / B;
        end
      end
      default: result = 4'bxxxx; // invalid opcode
    endcase
  end

endmodule