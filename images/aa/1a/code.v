module top_module(clk,
           reset,
           d,
           q,
           qb);input d,clk,reset;
output reg q;
output qb;


 
always@ (posedge clk)
	begin
	
	if (reset)
	q = 0;
else 
	q = d;
 
	end
assign	qb = ~ q;
	
endmodule