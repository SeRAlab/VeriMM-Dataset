module top_module(
		input signed [15:0] in1, in2,
		output reg [1:0] result
	);reg signed [15:0] diff;
	always@(*) begin
		diff = in1 - in2;	
		
		if (diff < 0)
			result <= 2'b11;
		else if (diff > 0)
			result <= 2'b10;
		else if (diff == 0)
			result <= 2'b01;
		else
			result <= 2'b00;		
	end
	
endmodule