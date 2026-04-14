module top_module(e,b1x,b2x,b3x,b4x,b5x,b6x,b7x,b8x,k);input	[1:48] e;
output	[1:6] b1x,b2x,b3x,b4x,b5x,b6x,b7x,b8x;
input	[1:48] k;
wire	[1:48] XX;

assign         XX = k ^ e;
assign        b1x = XX[1:6];
assign        b2x = XX[7:12];
assign        b3x = XX[13:18];
assign        b4x = XX[19:24];
assign        b5x = XX[25:30];
assign        b6x = XX[31:36];
assign        b7x = XX[37:42];
assign        b8x = XX[43:48];

endmodule