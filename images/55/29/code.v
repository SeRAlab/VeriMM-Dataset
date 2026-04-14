module top_module(clk);output clk;
reg tmp;
	always
	begin
		#1
		tmp = 0;
		tmp = 1;
	end
assign clk = tmp;endmodule