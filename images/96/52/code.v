module top_module(
   
   clk_50m, locked,
   
   clk_in, resetn
   );input clk_in;
   output clk_50m;
   input  resetn;
   output locked;

   
   

   
   
   reg                  clk_50m;
   reg                  locked;
   
   

   assign locked = resetn;
   assign clk_50m = clk_in;



endmodule