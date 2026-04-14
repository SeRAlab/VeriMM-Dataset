module top_module(a,r,out,out_r);input wire a,r;
output wire out, out_r;

assign  out = (~r)&&a; 
assign  out_r = r||a;

endmodule