module top_module(q, d, clk, enable, reset);output q;
   input  d, clk, enable, reset;
   reg 	  q;

   always @(posedge reset)
     q<= 1'b0;
   always @(posedge clk)
     if (enable) q <= d;endmodule