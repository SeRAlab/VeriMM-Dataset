module top_module(clk,baud,baud16,rst);input clk,rst;
	output baud;
	output baud16;
	
	parameter b_rate = 57600;
	parameter c_rate = 25000000; /* 25 Mhz */
	parameter divider = c_rate / b_rate;
	parameter divider16 = c_rate / (16 * b_rate); /* 16 times faster! */
	
	reg [31:0] count,count16;
	
	assign baud = (count == 0) ? 1 : 0;
	assign baud16 = (count16 == 0) ? 1 : 0;
	
	always @(negedge clk) begin
		count = count + 1;
		count16 = count16 + 1;
		if (count == divider)
			count = 0;
		if (count16 == divider16) 
			count16 = 0;
		if (rst) begin
			count = 0;
			count16 = 0;
		end
	end
endmodule