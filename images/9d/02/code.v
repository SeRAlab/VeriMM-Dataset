module top_module(Clock, Reset, Set, Load, Enable, In, Count);parameter		width = 		9,
				limited =		0;
	

	
	
	
	input			Clock, Enable, Reset, Set, Load;
	input	[width-1:0]	In;
	output	[width-1:0]	Count;
	

	
	
	
	reg	[width-1:0]	Count;
	wire			NoLimit;
	

	
	
	
	assign	NoLimit =				!limited;
	

	
	
	
	always @ (posedge Clock) begin
		if (Reset) Count <=						{width{1'b0}};
		else if (Set) Count <=						{width{1'b1}};
		else if (Load) Count <=						In;
		else if (Enable & (NoLimit | ~&Count)) Count <=			Count + 9'd2;
	end
	
endmodule