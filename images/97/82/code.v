module top_module(
	input clock_i,
	input D,
	input S,
	input R,
	output Q
);reg out;	// Need to reset before use, default is powerup high
	
	assign Q = out;
	
	always @(posedge clock_i)
	begin
		if( S ) 
			out <= 1'b1;
		else if( R )
			out <= 1'b0;
		else
			out <= D;
	end
endmodule