module top_module(
   // Outputs
   output reg z,
   // Inputs
   input a, b
   );parameter DELAY = 1;

   always @ (a or b) begin
      #DELAY z = a ^ b;
   end

endmodule