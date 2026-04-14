module dffrl_s (din, clk, rst_l, q, se, si, so);
parameter SIZE = 1;
input	[SIZE-1:0]	din ;	
input			clk ;	
input			rst_l ;	
output	[SIZE-1:0]	q ;	
input			se ;	
input	[SIZE-1:0]	si ;	
output	[SIZE-1:0]	so ;	
reg 	[SIZE-1:0]	q ;
`ifdef NO_SCAN
always @ (posedge clk)
	q[SIZE-1:0]  <= rst_l ? din[SIZE-1:0] : {SIZE{1'b0}};
`else
always @ (posedge clk)
	q[SIZE-1:0]  <= rst_l ? ((se) ? si[SIZE-1:0]  : din[SIZE-1:0] ) : {SIZE{1'b0}};
assign so[SIZE-1:0] = q[SIZE-1:0] ;
`endif
endmodule