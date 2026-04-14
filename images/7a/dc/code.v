module top_module(
   // Inputs
   clk, in, reset,
   // Outputs
   out
   );input clk, in, reset;
   output reg out;

   reg prev_in;
   wire toggle;

   always @(posedge clk or negedge reset) begin
      if (!reset) begin
         out <= 1'b0;
         prev_in <= 1'b0;
      end
      else begin
         prev_in <= in;
         out <= toggle;
      end
   end

   assign toggle = (in & ~prev_in) ? ~out : out;

endmodule