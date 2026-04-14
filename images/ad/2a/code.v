module top_module(
   
   x,
   
   clk
   );`ifdef ALLOW_UNOPT
   
`endif

   input clk;
   output [31:0] x;  

   reg [31:0] x;
   always @* begin
      x = x ^ $random;
   end

endmodule