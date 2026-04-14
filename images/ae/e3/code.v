module top_module(clk, set_ena, up, down, BCD_out_next, TC);parameter TOP_VALUE = 9;
	

	
	input clk;
	
	input set_ena;
	input up, down;
	output reg [3:0] BCD_out_next;
	reg [3:0]BCD_out = 0;
	output reg TC;
	
	
	always@(*) begin
		BCD_out_next = BCD_out;
		if (set_ena == 1'b0) begin
			if (BCD_out == TOP_VALUE) BCD_out_next = 0;
			else BCD_out_next = BCD_out + 1'b1;
		end
		else if (up == 1'b0) begin
				if (BCD_out == TOP_VALUE) BCD_out_next = 0;
				else BCD_out_next = BCD_out + 1'b1;
			end
			else if (down == 1'b0) begin
				if (BCD_out == 0) BCD_out_next = TOP_VALUE;
				else BCD_out_next = BCD_out - 1'b1;
			end
			else BCD_out_next = BCD_out;
		
	end
	always@(posedge clk) begin
		BCD_out <= BCD_out_next;
		
	end
	
	always@(posedge clk or posedge set_ena) begin
		if (set_ena == 1'b1) TC <= 1'b0; 
		else if (BCD_out == TOP_VALUE) TC <= 1'b1;
		else TC <= 1'b0;
	end
	
	
endmodule