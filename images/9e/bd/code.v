module top_module(
   
   clk
   );input clk;

   integer count;
   assign count = $countbits(32'h123456, '0, '1, 'x, 'z);

endmodule