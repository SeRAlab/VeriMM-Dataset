module top_module(
		in_clock,
		divisor,
		cs,
		i2cclk
);input 			in_clock;
		input [9:0]		divisor;
		input				cs;
		output			i2cclk;





reg	[10:0]	COUNT = 11'd0;		
reg				CLK = 1'b0;			




		
always @(posedge in_clock)
begin
	if (cs == 1)
	begin
		COUNT <= COUNT + 1;
		if (COUNT > divisor)
		begin
			COUNT <= 0;
			CLK <= !CLK;
		end
	end
end

assign i2cclk = CLK;

endmodule