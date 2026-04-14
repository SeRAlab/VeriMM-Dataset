module top_module(
  input [7:0] a,
  input [7:0] b,
  input [1:0] op,
  input clk,
  output reg [7:0] result
);always @(posedge clk) begin
    case(op)
      2'b00: // addition
        begin
          if((a[7] & b[7]) || (a[7] & ~result[7] & ~b[7]) || (~a[7] & result[7] & b[7])) begin
            // overflow
            result <= 8'b11111111;
          end else if((a[7] & ~b[7] & ~result[7]) || (~a[7] & b[7] & ~result[7]) || (~a[7] & ~b[7] & result[7])) begin
            // underflow
            result <= 8'b00000000;
          end else begin
            // normal addition
            result <= a + b;
          end
        end
      2'b01: // subtraction
        begin
          if((a[7] & ~b[7] & ~result[7]) || (~a[7] & b[7] & ~result[7]) || (~a[7] & ~b[7] & result[7])) begin
            // underflow
            result <= 8'b00000000;
          end else if((a[7] & b[7] & ~result[7]) || (~a[7] & ~b[7] & ~result[7]) || (~a[7] & b[7] & result[7])) begin
            // overflow
            result <= 8'b11111111;
          end else begin
            // normal subtraction
            result <= a - b;
          end
        end
      2'b10: // multiplication
        begin
          result <= a * b;
        end
      2'b11: // division
        begin
          if(b == 8'b00000000) begin
            // division by zero
            result <= 8'b11111111;
          end else begin
            result <= a / b;
          end
        end
    endcase
  end

endmodule