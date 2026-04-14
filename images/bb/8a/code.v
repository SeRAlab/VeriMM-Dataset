module top_module(
   // Outputs
   output reg out,
   // Inputs
   input clk,
   input in,
   input reset
);always @(posedge clk or posedge reset) begin
      if (reset) begin
         out <= 1'b0;
      end else if (in) begin
         out <= ~out;
      end
   end
   
endmodule