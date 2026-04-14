module top_module(clk,reset,q);input clk;
input reset;
output [4:0] q;
reg [4:0] current_state;
reg [4:0] next_state;

   always @ (reset or current_state) 
   begin
      if (reset==1)
               next_state = 0;  
      else
         next_state = incr(current_state);
   end   

   assign q = current_state;    

   always @ (posedge clk)
   begin
      current_state <= next_state;  
   end    

   function [4:0] incr;            
    input [4:0] n;
    reg  c;
    integer i;
    begin    
      c=1;
      for (i = 0; i<=4; i=i+1)
      begin
        incr[i] = n[i] ^ c;
        c = n[i] & c;
      end
    end
   endfunction

endmodule