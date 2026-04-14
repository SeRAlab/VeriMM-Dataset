module top_module(
   
   fastclk, reset_l
   );input fastclk;
   input reset_l;

   always @ (posedge fastclk) begin
      
      
      if (reset_l) ;
   end
endmodule