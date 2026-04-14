module top_module(
	clk, 		
	enable, 	
	reset, 		
	framesize, 	
	in, 		
	out, 		
	complete	
);parameter BITS = 136;		
	parameter BITS_COUNTER = 8;	
	parameter COUNTER_MAX = 8'hFF;	
	
	input clk, enable, reset, in;
	input [BITS_COUNTER-1:0] framesize;
	
	output reg complete;
	output reg [BITS-1:0] out;
	reg [BITS_COUNTER-1:0] counter;	
		
	always@(posedge reset) begin
		out = 0;
		counter = framesize;
		complete = 0;
	end
	
	
	always@(posedge clk) begin
		if(enable) begin
			if(~complete) begin	
				out[counter] <= in;
				counter = counter - 1;	
			end
		end else begin
			complete = 0;
		end
	end
	
	always@(counter) begin
		if(counter == COUNTER_MAX) begin	
			complete = 1;
		end
		
	end
	
	always@(complete) begin
		counter = framesize;	
	end
	
endmodule