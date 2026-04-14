module top_module(
   // Inputs
   data_in,
   enable,
   reset_l,
   clk,          // Add clk as an input
   // Outputs
   data_out
   );input data_in;
   input enable;
   input reset_l;
   input clk;     // Declare clk as an input
   output reg data_out;

   always @(posedge clk) begin
      if (reset_l == 0) begin
         data_out <= 0;
      end else if (enable == 1) begin
         data_out <= data_in;
      end
   end

endmodule