module top_module(S, T, quote, rem);input      [31:0] S, T;          
   output reg [31:0] quote, rem;    
   
   integer           int_S, int_T;
   
   always@(S, T) begin
      int_S = S;                    
      int_T = T;

      quote = int_S / int_T;        
      
      rem   = int_S % int_T;        
      
   end

endmodule