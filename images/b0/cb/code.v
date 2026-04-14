module top_module(
   input clk,
   input rst,
   output t);reg [2:0] count = 0;
   
   assign t = (count == 3'd5);
   
   always @(posedge clk) begin
      if (rst | t)
         count <= 0;
      else
         count <= count + 1;
   end
   
endmodule