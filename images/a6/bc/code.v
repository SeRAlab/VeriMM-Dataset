module top_module(clk, reset, enable, count);input clk, reset, enable;
   output reg [2:0] count;
   
   always @(posedge clk or posedge reset)
   begin
      if(reset)
         count <= 3'b0;
      else if(enable)
         count <= count + 1;
   end
   
endmodule