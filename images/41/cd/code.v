module top_module(/*AUTOARG*/
   // Inputs
   clk,
   xvecin,
   // Outputs
   xvecout
   );input clk;
   input wire [1:0] xvecin;

   output wire [1:0] xvecout;

   assign xvecout = {xvecin[0], clk};

endmodule