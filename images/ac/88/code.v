module top_module(sypush,push,clk,rst);input push,clk,rst;
	output sypush;
	wire push,clk,rst;
	reg sypush;

	always @(posedge clk or posedge rst)
	begin
		if (rst) sypush <=0;
		else sypush <=push;
	end
endmodule