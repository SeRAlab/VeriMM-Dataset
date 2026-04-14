module top_module(clock,out);input clock;
	
	output reg [1:0] out;
	
	always @(posedge clock)
	begin
		if(out < 2)		
			out = out + 1;
		else
			out = 0;
	end
	
endmodule