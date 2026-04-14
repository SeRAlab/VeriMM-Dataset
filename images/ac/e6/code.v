module top_module(
   
   clk, toggle
   );input clk;
   input toggle;

   
   always @ (posedge clk) begin
      if (toggle) begin
         $write("");  
         
      end
   end
   
   always @ (posedge clk) begin
      if (toggle) begin
         
         $write("");
         if (0) ;  
      end
   end

endmodule