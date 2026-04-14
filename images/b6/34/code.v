module top_module(
   
   x,
   
   clk
   );`ifdef ALLOW_UNOPT
   
`endif

   input clk;
   output x;   

   reg x;
   always @* begin
      x = ~x;
   end

endmodule