module top_module(q,qbar,clk,rst,d);output reg q;
	output qbar;
	input clk, rst;
	input d;

	assign qbar = ~q;

  
  
	always @(posedge clk, posedge rst)
	begin
		if (rst)
			q <= 0;
		else
			q <= d;
	end
endmodule