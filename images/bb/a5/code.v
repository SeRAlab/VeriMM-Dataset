module top_module(
			clk,rst_n,
			clk_div	
		);input clk;		
input rst_n;	

output clk_div;	


reg[19:0] cnt;	

always @ (posedge clk or negedge rst_n)	
	if(!rst_n) cnt <= 20'd0;
	else cnt <= cnt+1'b1;	


reg clk_div_r;	

always @ (posedge clk or negedge rst_n) 
	if(!rst_n) clk_div_r <= 1'b0;
	else if(cnt == 20'hfffff) clk_div_r <= ~clk_div_r;	

assign clk_div = clk_div_r;	

endmodule