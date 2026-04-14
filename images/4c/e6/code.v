module top_module(
		  clk,
		  rst,
		  fpu_op_i,
		  fracta_i,
		  fractb_i,
		  signa_i,
		  signb_i,
		  fract_o,
		  sign_o);parameter FP_WIDTH = 32;
   parameter MUL_SERIAL = 0; 
   parameter MUL_COUNT = 11; 
   parameter FRAC_WIDTH = 23;
   parameter EXP_WIDTH = 8;
   parameter ZERO_VECTOR = 31'd0;
   parameter INF = 31'b1111111100000000000000000000000;
   parameter QNAN = 31'b1111111110000000000000000000000;
   parameter SNAN = 31'b1111111100000000000000000000001;
   
   input clk;
   input rst;
   
   input fpu_op_i;   
   input [FRAC_WIDTH+4:0] fracta_i;
   input [FRAC_WIDTH+4:0] fractb_i;
   input 		  signa_i;
   input 		  signb_i;
   output reg [FRAC_WIDTH+4:0] fract_o;
   output reg 		       sign_o;
   
   wire [FRAC_WIDTH+4:0]       s_fracta_i;
   wire [FRAC_WIDTH+4:0]       s_fractb_i;
   wire [FRAC_WIDTH+4:0]       s_fract_o;
   wire 		       s_signa_i, s_signb_i, s_sign_o;   
   wire 		       s_fpu_op_i;
   
   wire 		       fracta_gt_fractb;
   wire 		       s_addop;
   
   assign s_fracta_i = fracta_i;
   assign s_fractb_i = fractb_i;
   assign s_signa_i  = signa_i;
   assign s_signb_i  = signb_i;
   assign s_fpu_op_i = fpu_op_i;
   
   always @(posedge clk or posedge rst)
     if (rst)
       begin
	  fract_o <= 'd0;
	  sign_o <= 1'b0;
       end
     else
       begin
	  fract_o <= s_fract_o;
	  sign_o <= s_sign_o;	
       end
   
   assign fracta_gt_fractb = s_fracta_i > s_fractb_i;
   
   
   assign s_addop = ((s_signa_i ^ s_signb_i) & !s_fpu_op_i) |
		    ((s_signa_i ^~ s_signb_i) & s_fpu_op_i);
   
   
   assign s_sign_o = ((s_fract_o == 28'd0) & !(s_signa_i & s_signb_i)) ? 1'b0 :
		     (!s_signa_i & (!fracta_gt_fractb & (fpu_op_i^s_signb_i)))|
		     (s_signa_i & (fracta_gt_fractb | (fpu_op_i^s_signb_i)));
   
   
   assign s_fract_o = s_addop ?
		      (fracta_gt_fractb ? s_fracta_i - s_fractb_i :
		       s_fractb_i - s_fracta_i) :
		      s_fracta_i + s_fractb_i;
   
   
endmodule