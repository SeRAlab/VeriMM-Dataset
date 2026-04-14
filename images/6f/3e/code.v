module top_module(a,in,y0,y1);input a,in;
output y0,y1;
assign y0 = (~a) & in;
assign y1 = a & in;
endmodule