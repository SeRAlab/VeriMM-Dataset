module top_module(reset_n, next_result, result);input reset_n; 
   input [63:0]next_result;
   output reg[63:0]result; 
   always@(next_result or reset_n)   begin 
      if(reset_n == 0) result<=63'b0; 
      else if(next_result==64'bx) result<=64'b0;
      else result<=next_result; 
      end 
   endmodule