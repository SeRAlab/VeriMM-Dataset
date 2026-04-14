module top_module(
   input [3:0] A,
   input [3:0] B,
   input [1:0] op,
   output reg [3:0] sum,
   output reg [3:0] diff,
   output reg [3:0] prod,
   output reg [3:0] quot
);always @* begin
   case (op)
      2'b00: begin // addition
         sum = A + B;
         diff = 4'b0;
         prod = 4'b0;
         quot = 4'b0;
      end
      2'b01: begin // subtraction
         sum = 4'b0;
         diff = A - B;
         prod = 4'b0;
         quot = 4'b0;
      end
      2'b10: begin // multiplication
         sum = 4'b0;
         diff = 4'b0;
         prod = A * B;
         quot = 4'b0;
      end
      2'b11: begin // division
         sum = 4'b0;
         diff = 4'b0;
         prod = 4'b0;
         if (B == 4'b0) // division by zero
            quot = 4'b0;
         else
            quot = A / B;
      end
      default: begin // invalid op
         sum = 4'b0;
         diff = 4'b0;
         prod = 4'b0;
         quot = 4'b0;
      end
   endcase
end

endmodule