module top_module(clk, rst_n, a, b, f);input clk, rst_n;
	input a, b;
	
	output reg f;








	always @ (posedge clk or negedge rst_n)
		begin
			if (!rst_n)
				begin
					f <= 0;
				end
			else
				begin
					f <= a & b;
				end
		end

endmodule