module top_module(ar,ai,br,bi,xr,xi,yr,yi,w0r,w0i);input    signed   [15:0]   xr ,xi ,yr ,yi  ;
input	 signed   [31:0]   w0r,w0i;
output   signed   [15:0]   ar ,ai ,br ,bi ;
wire     signed   [47:0]   dick_re1 , dick_im1 , dick_re2 , dick_im2 ;
wire	 signed	  [47:0]   far ,fai ,fbr ,fbi ;

assign dick_re1 = yr * w0r ;
assign dick_re2 = yi * w0i ;
assign dick_im1 = yr * w0i ;
assign dick_im2 = yi * w0r ;
assign    far    = (xr<<16) + dick_re1 - dick_re2 ;
assign    fai    = (xi<<16) + dick_im1 + dick_im2 ;
assign    fbr    = (xr<<16) - dick_re1 + dick_re2 ;
assign    fbi    = (xi<<16) - dick_im1 - dick_im2 ;
assign   ar     = far[31:16];
assign   ai     = fai[31:16];
assign   br     = fbr[31:16];
assign   bi     = fbi[31:16];endmodule