module top_module(
   clk,
   rst,
   fric_in,
   fric_out
   );input           clk;
   input 	   rst;
   input [7:0] 	   fric_in;
   input [7:0]     fric_out;

   wire [7:0] 	   fric_out_i;
   wire [7:0] 	   fric_in_i;
   
   assign #1 	   fric_out_i = fric_out;
   assign #1 	   fric_in_i = fric_in;
   

endmodule