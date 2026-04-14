module top_module(
	input clk,
	input reset,
	
	input [10:0] ObjectX,		
	input [9:0] ObjectY,		
	input [9:0] ObjectW,		
	input [8:0] ObjectH,		
	
	input [9:0] PollX,			
	input [8:0] PollY,			
	
	output Hit					
	);reg hit_out;
	
	
	always @ (posedge clk)
	begin
		if(reset)
		begin
			hit_out <= 1'b0;
		end
		else
		begin
			hit_out <= (ObjectX <= PollX & PollX <= ObjectX+ObjectW)&(ObjectY <= PollY & PollY <= ObjectY+ObjectH);
		end
	end
	
	assign Hit = hit_out;

endmodule