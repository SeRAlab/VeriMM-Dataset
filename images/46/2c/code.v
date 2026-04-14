module top_module(clk, rst, out);input clk, rst;
	
	output [1:0]out;
	assign out=cnt[9:8];
	
	reg [9:0]cnt;
	
	always@(posedge clk or posedge rst)begin
		if(rst) cnt<=10'd0;
		else cnt<=cnt+10'd1;
	end
endmodule