module top_module(
   
   out,
   
   clk, in
   );input clk;
   input logic [2:0][1:0] in;

   output logic [1:0][1:0] out;

   always @(posedge clk) begin
      out <= in[2 -: 2];
   end
endmodule