module top_module(a,b,c,d,w,x,y,z);input a,b,c,d;
	output w,x,y,z;
	assign {w,x,y,z}={a,b,c,d}+2'b11;
endmodule