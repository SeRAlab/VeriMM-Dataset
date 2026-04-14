module top_module(
   // Inputs
   clk,
   reset,
   a,
   b,
   op,

   // Outputs
   result
   );input clk, reset;
   input [3:0] a, b;
   input op;
   output reg [3:0] result;

   always @ (posedge clk) begin
      if (reset) begin
         result <= 4'b0;
      end else begin
         if (op == 0) begin
            result <= a + b;
         end else begin
            result <= a - b;
         end
      end
   end

endmodule