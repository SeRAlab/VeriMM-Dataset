module top_module(

   input  wire [4:0]  Bin,      
   output reg  [31:0] Bout      

   ) ;integer i ;

   always @(*) begin

      for(i=0; i < 32; i=i+1) begin

         Bout[i] = (Bin[4:0] >= i) ;      

      end  
   end  

endmodule