module top_module(S, T, rem, qout);input      [31:0]      S, T;     
   output reg [31:0] rem, qout;     
   
   integer int_s, int_t;            
   
   
   always@(*) begin
      int_s <= S;
      int_t <= T;
   end
   
   
   always@(*) begin
         qout = int_s / int_t;      
         rem  = int_s % int_t;      
   end                           

endmodule