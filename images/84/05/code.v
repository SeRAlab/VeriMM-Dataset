module top_module(
   
   out,
   
   clk, in, n
   );input clk;
   input [7:0] in;
   input [2:0]  n;
   output reg out;

   

   always @(posedge clk) begin
      out <= in[n];
   end
endmodule