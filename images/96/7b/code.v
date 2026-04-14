module top_module(a, b, op, result, valid);input [7:0] a, b;
   input [1:0] op;
   output reg [7:0] result;
   output reg valid;

   always @(*) begin
      case (op)
         2'b00: result = a + b;
         2'b01: result = a - b;
         2'b10: result = a * b;
         2'b11: begin
            if (b == 0) begin
               result = 8'b0;
               valid = 1'b0;
            end else begin
               result = a / b;
               valid = 1'b1;
            end
         end
      endcase

      if (op == 2'b11 && b == 0) begin
         valid = 1'b0;
      end else begin
         valid = 1'b1;
      end
   end
endmodule