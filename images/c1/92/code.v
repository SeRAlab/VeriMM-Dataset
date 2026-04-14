module dffe_ns (din, en, clk, q);
parameter SIZE = 1;
input	[SIZE-1:0]	din ;	
input			en ;	
input			clk ;	
output	[SIZE-1:0]	q ;	
reg 	[SIZE-1:0]	q ;
always @ (posedge clk)
  q[SIZE-1:0] <= en ? din[SIZE-1:0] : q[SIZE-1:0];
endmodule