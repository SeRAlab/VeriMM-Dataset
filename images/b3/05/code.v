module top_module(input clk, reset_n, start, enable, input [7:0] delay, output done);parameter BASIC_PERIOD=20'd500000;   
parameter CLOCK_SPEED=32'd50000000;
parameter COUNTER1 = 20'd500000;	

reg [7:0] internal_delay;
reg[20:0] counter1;
reg counter1_done;
reg[20:0] counter2;
reg loaded;
reg done_reg;

always @(posedge clk)
begin
	if (reset_n == 1'b0)
	begin
		counter1 = 21'b0;
		counter2 = 21'b0;
		loaded = 1'b0;
		done_reg = 1'b0;
	end
	
	if(start == 1'b1)
	begin
		internal_delay = delay;
		counter1 = 21'd0;
		counter2 = internal_delay;
	end
	
	if (enable == 1'b1)
	begin
		if (counter1 < COUNTER1)
		begin
			counter1 = counter1 + 21'd1;
		end
		else if (counter1 >= COUNTER1)
		begin
			if (counter2 > 0)
			begin
				counter2 = counter2 - 21'd1;
			end
			else if (counter2 <= 0)
			begin
				done_reg = 1'b1;
			end
		end
	end
	else if (enable == 1'b0)
	begin
		done_reg = 1'b0;
		counter1 = 21'd0;
		counter2 = 21'd0;
	end
end

assign done = done_reg;

endmodule