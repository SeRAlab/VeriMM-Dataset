module top_module(
	
	output reg[9:0] LEDR,

	
	input kData, 
	input kClock 
);reg [10:0] code;
	integer count = 0;

	always@(negedge kClock) 
		begin
		code[count] = kData;
		count = count + 1;			
		if(count == 11)
		begin
			LEDR = code[8:1];
			count = 0;
		end
	end

endmodule