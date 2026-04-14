module top_module(clk, rst_n, signal, neg_flag, pos_flag);input clk, rst_n;
	input signal;
	
	output neg_flag, pos_flag;

	reg buffer1, buffer2;
	
	always @ (posedge clk or negedge rst_n)
		begin
			if (!rst_n)
				begin
					buffer1 <= signal;
					buffer2 <= signal;
				end
			else
				begin
					buffer1 <= signal;
					buffer2 <= buffer1;
				end
		end

	assign neg_flag = buffer2 && ~buffer1;
	assign pos_flag = ~buffer2 && buffer1;
		
endmodule