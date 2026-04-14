module edge_det(rst, clk, ce, i, pe, ne, ee);
input rst;		
input clk;		
input ce;		
input i;		
output pe;		
output ne;		
output ee;		
reg ed;
always @(posedge clk)
	if (rst)
		ed <= 1'b0;
	else if (ce)
		ed <= i;
assign pe = ~ed & i;	
assign ne = ed & ~i;	
assign ee = ed ^ i;		
endmodule