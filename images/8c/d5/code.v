module top_module(
   // Inputs
   clk,
   fastclk,
   reset_l,
   // Outputs
   out_clk,
   out_fastclk
   );input clk;
   input fastclk;
   input reset_l;
   output out_clk;
   output out_fastclk;

   reg fastclk_reg;
   reg out_fastclk; // Declare out_fastclk as a reg

   assign out_clk = clk;
   
   always @ (posedge clk) begin
      if (!reset_l) begin // Change to active-low reset
         fastclk_reg <= 1'b0;
         out_fastclk <= 1'b0;
      end
      else begin
         fastclk_reg <= fastclk;
         out_fastclk <= fastclk_reg;
      end
   end

endmodule