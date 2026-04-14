module top_module(ar,ai,br,bi,xr,xi,yr,yi,w0r,w0i);input     signed    [15:0]   xr ,yr ,xi ,yi ;
input     signed    [31:0]   w0r , w0i ;
output    signed    [15:0]   ar ,ai ,br ,bi  ;

assign ar = xr + yr ;
assign ai = xi ;
assign br = xr - yr ;
assign bi = xi ;endmodule