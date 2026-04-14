module top_module(
   
   outp,
   
   reset, clk, inp
   );input		  reset;
   input		  clk;
   input [31:0] 	  inp;
   output [31:0] 	  outp;

   function [31:0] no_inline_function;
      input [31:0] 	  var1;
      input [31:0] 	  var2;
      
      reg [31*2:0] 	  product1 ;
      reg [31*2:0] 	  product2 ;
      integer 		  i;
      reg [31:0] 	  tmp;

      begin
	 product2 = {(31*2+1){1'b0}};

	 for (i = 0; i < 32; i = i + 1)
	   if (var2[i]) begin
	      product1 = { {31*2+1-32{1'b0}}, var1} << i; 
	      product2 = product2 ^ product1;
	   end
	 no_inline_function = 0;

	 for (i= 0; i < 31; i = i + 1 ) 
	   no_inline_function[i+1] = no_inline_function[i] ^ product2[i] ^ var1[i];
      end
   endfunction

   reg [31:0] outp;
   reg [31:0] inp_d;

   always @( posedge clk ) begin
      if( reset ) begin
	 outp <= 0;
      end
      else begin
	 inp_d <= inp;
	 outp <= no_inline_function(inp, inp_d);
      end
   end

endmodule