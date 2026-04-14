module top_module(
	input wire clock, reset_n, en_d, 
	output frame_en
);reg [19:0] delay;

	always @(posedge clock)
		begin: delay_counter
			if (!reset_n)
				
				delay <= 20'd5;
			else if (en_d == 1'b1)
				begin
					if (delay == 0)
						delay <= 20'd833_334;
						
					else
						delay <= delay - 1'b1;
				end
		end
		assign frame_en = (delay == 20'd0) ? 1 : 0;endmodule