module top_module(
  input [3:0] A,
  input [3:0] B,
  input [1:0] Op,
  input RST,
  output reg [7:0] Result,
  output reg Overflow
);always @(A, B, Op, RST) begin
    if (RST) begin
      Result <= 0;
      Overflow <= 0;
    end else begin
      case (Op)
        2'b00: begin // Addition
          Result <= A + B;
          Overflow <= (Result > 8'hFF);
        end
        2'b01: begin // Subtraction
          Result <= A - B;
          Overflow <= (Result < 0);
        end
        2'b10: begin // Multiplication
          Result <= A * B;
          Overflow <= (Result > 8'hFF);
        end
        2'b11: begin // Division
          if (B == 0) begin
            Result <= 0;
            Overflow <= 0;
          end else begin
            Result <= A / B;
            Overflow <= (Result > 8'hFF);
          end
        end
        default: begin // Invalid operation
          Result <= 0;
          Overflow <= 0;
        end
      endcase
    end
  end

endmodule