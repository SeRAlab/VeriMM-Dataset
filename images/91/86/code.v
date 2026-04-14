module top_module(ena,fetch,rst,clk);input fetch,rst,clk;
output ena;
reg ena;
reg state;

always @(posedge clk)
begin 
	if(rst)	ena <=0;
	else 
	if(fetch)
	ena <=1;
end

endmodule