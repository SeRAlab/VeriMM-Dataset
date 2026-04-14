module top_module(e, d, q, q_not);input wire e, d;              
   output reg q, q_not;          

   always @(posedge e) begin     
      q = d;                     
      q_not = ~d;                
   end
endmodule