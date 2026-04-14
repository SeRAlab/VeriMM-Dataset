module top_module(
   input [1:0] in,
   output      out_and,
   output      out_nand,
   output      out_or,
   output      out_nor,
   output      out_xor,
   output      out_xnor
   );assign out_and  = &in;  
   assign out_nand = ~&in;  
   assign out_or   = |in;  
   assign out_nor  = ~|in;  
   assign out_xor  = ^in;  
   assign out_xnor = ~^in;
   
endmodule