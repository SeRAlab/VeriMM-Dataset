module top_module(
   
   clk, toggle
   );input clk;
   input toggle;

   

   always @ (posedge clk) begin
      $write("");  
      if (0) begin  
         
         $write("");
      end
      if (toggle) begin  
         
         $write("");
      end
      if (toggle) begin : block
         
`ifdef ATTRIBUTE
         
`endif
         begin end  
         if (1) begin end  
         $write("");  
      end
   end
endmodule