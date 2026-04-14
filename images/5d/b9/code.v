module top_module(scanline, pixels);input [2:0] scanline;
	output [3:0] pixels;
	parameter a=0,b=0,c=0,d=0,e=0;
	assign pixels = scanline == 3'd0 ? 		   {a[0],a[1],a[2],a[3]} :
        				scanline == 3'd1 ? {b[0],b[1],b[2],b[3]} :
        				scanline == 3'd2 ? {c[0],c[1],c[2],c[3]} :
        				scanline == 3'd3 ? {d[0],d[1],d[2],d[3]} :
        				scanline == 3'd4 ? {e[0],e[1],e[2],e[3]} : 4'b0000;
endmodule