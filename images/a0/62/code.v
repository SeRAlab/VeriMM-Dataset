module top_module(adr_i, validate, invalidate,
   cached_adr_o, cache_hit, adr_valid,
   clk, rst);parameter full_adr_width = 32;
   parameter word_adr_width = 2; 
   parameter line_adr_width = 8; 

   parameter tag_width = full_adr_width - line_adr_width - word_adr_width;
   
   
   input [full_adr_width-1: word_adr_width + line_adr_width] adr_i;
   input 		 validate;
   input 		 invalidate;
   output [full_adr_width-1: word_adr_width + line_adr_width] cached_adr_o;   
   output 		  cache_hit;
   output reg 		  adr_valid;
   
   input 		  clk, rst;
   
   reg [tag_width-1:0] 	  cached_adr;

   assign cached_adr_o = cached_adr;   

   always @(posedge clk)
     if (rst)
       cached_adr <= 0;
     else if (validate)
       cached_adr <= adr_i;
   
   always @(posedge clk)
     if (rst)
       adr_valid <= 0;
     else if (validate)
       adr_valid <= 1;
     else if (invalidate)
       adr_valid <= 0;
   
   assign cache_hit = (adr_i == cached_adr);

endmodule