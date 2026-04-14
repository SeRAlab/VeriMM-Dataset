module top_module(S, T, prdct);input      [31:0] S, T;          
   output reg [63:0] prdct;         
   
   integer           int_S, int_T;
   
   always@(S, T) begin
      int_S = S;                    
      int_T = T;

      prdct = int_S * int_T;        

   end

endmodule