module top_module(clk, rst, clr, cnt);input clk, rst;
	input clr;

	output [3:0] cnt;
		reg [3:0] cnt;

	always @(posedge clk or negedge rst)
	begin
		if(!rst)
			cnt <= 4'd0;
		else
			if(clr)
				cnt <= 4'd0;
			else
				cnt <= cnt + 4'd1;
	end

endmodule