module top_module(
	input  wire prev,  
	input  wire req,   
	output reg  next, 

	input  wire loop_in, 
	output reg  loop_out 
);always @*
	begin
		if( prev )
		begin
			loop_out = 1'b1;
		end
		else 
		begin
			loop_out = req ? 1'b0 : loop_in;
		end
	end

	always @*
	begin
		next = req ? loop_in : 1'b0;
	end

endmodule