module top_module(
	input clk,
	input rst,
	input[7:0] data,
	input set_delay,
	input set_sound,
	output reg[7:0] delay_timer,
	output reg[7:0] sound_timer
);reg[20:0] counter;
	parameter[20:0] COUNTER_MAX = 1666666;
	always @(posedge clk, posedge rst) begin
		if(rst) begin
			counter <= 21'd0;
		end
		else begin
			if(counter < COUNTER_MAX) begin
				counter <= counter + 21'd1;
			end
			else begin
				counter <= 21'd0;
			end
		end
	end
	
	
	always @(posedge clk, posedge rst) begin
		if(rst) begin
			delay_timer <= 8'd0;
			sound_timer <= 8'd0;
		end
		else begin
			
			if(counter == COUNTER_MAX) begin
				if(delay_timer > 0) begin
					delay_timer <= delay_timer - 8'd1;
				end
				if(sound_timer > 0) begin
					sound_timer <= sound_timer - 8'd1;
				end
			end
			
			
			if(set_delay) begin
				delay_timer <= data;
			end
			
			if(set_sound) begin
				sound_timer <= data;
			end
		end
	end
endmodule