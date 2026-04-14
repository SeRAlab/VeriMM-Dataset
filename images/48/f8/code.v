module top_module(
	input wire clk,		
	input wire clr,		
	output wire dclk,		
	output wire segclk	
	);reg [17:0] q;

	
	
	
	always @(posedge clk or posedge clr)
	begin
		
		if (clr == 1)
			q <= 0;
		
		else
			q <= q + 1;
	end

	
	assign segclk = q[17];

	
	assign dclk = q[1];

endmodule