module top_module(
   
   out,
   
   in, sel
   );parameter IN_WIDTH=8;
   parameter OUT_WIDTH=2;

   input [IN_WIDTH*OUT_WIDTH-1:0] in;
   output [OUT_WIDTH-1:0]         out;
   input [31:0] 		  sel;

   wire [OUT_WIDTH-1:0] out = selector(in,sel);

   function [OUT_WIDTH-1:0] selector;
      input [IN_WIDTH*OUT_WIDTH-1:0] inv;
      input [31:0] 		  selv;
      integer i;
      begin
	 selector = 0;
	 for (i=0; i<OUT_WIDTH; i=i+1) begin
	    selector[i] = inv[selv*OUT_WIDTH+i];
	 end
      end
   endfunction
endmodule