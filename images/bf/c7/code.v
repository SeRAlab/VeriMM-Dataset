module dffrle_s (din, rst_l, en, clk, q, se, si, so);
parameter SIZE = 1;
input	[SIZE-1:0]	din ;	
input			en ;	
input			rst_l ;	
input			clk ;	
output	[SIZE-1:0]	q ;	
input			se ;	
input	[SIZE-1:0]	si ;	
output	[SIZE-1:0]	so ;	
reg 	[SIZE-1:0]	q ;
`ifdef NO_SCAN
always @ (posedge clk)
	 q[SIZE-1:0]  <= (rst_l ? ((en) ? din[SIZE-1:0] : q[SIZE-1:0]) : {SIZE{1'b0}}) ;
`else
always @ (posedge clk)
	q[SIZE-1:0]  <= se ? si[SIZE-1:0]  : (rst_l ? ((en) ? din[SIZE-1:0] : q[SIZE-1:0]) : {SIZE{1'b0}}) ;
assign so[SIZE-1:0] = q[SIZE-1:0] ;
`endif
endmodule