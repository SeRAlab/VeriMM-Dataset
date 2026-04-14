module top_module(
  input enable,
  input signed [31:0] dividend,
  input signed [31:0] divisor,
  output reg done,
  output reg signed [31:0] quotient,   // Changed from wire to reg
  output reg signed [31:0] remainder   // Changed from wire to reg
);reg signed [31:0] dividend_reg;
  reg signed [31:0] divisor_reg;
  reg signed [31:0] quotient_reg;
  reg signed [31:0] remainder_reg;
  reg [1:0] state;

  always @(*) begin
    case (state)
      2'b00: begin // Idle state
        if (enable) begin
          dividend_reg <= dividend;
          divisor_reg <= divisor;
          state <= 2'b01; // Start state
        end
      end
      2'b01: begin // Start state
        if (divisor == 0) begin
          quotient_reg <= 0;
          remainder_reg <= 0;
          done <= 1;
          state <= 2'b00; // Idle state
        end else begin
          quotient_reg <= dividend_reg / divisor_reg;
          remainder_reg <= dividend_reg % divisor_reg;
          state <= 2'b10; // Done state
        end
      end
      2'b10: begin // Done state
        done <= 1;
        quotient <= quotient_reg;
        remainder <= remainder_reg;
        state <= 2'b00; // Idle state
      end
      default: begin
        state <= 2'b00; // Idle state
      end
    endcase
  end

endmodule