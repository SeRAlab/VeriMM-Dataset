module top_module(
		
		input	wire	[30-1:0]	i_addr,
		output	reg			o_cachable
		
	);always @(*)
	begin
		o_cachable = 1'b0;
		
		
		
		
		if ((i_addr[29:0] & 30'h3e000000) == 30'h1a000000)
			o_cachable = 1'b1;
		
		if ((i_addr[29:0] & 30'h3e000000) == 30'h1c000000)
			o_cachable = 1'b1;
		
		
		if ((i_addr[29:0] & 30'h20000000) == 30'h20000000)
			o_cachable = 1'b1;
	end

endmodule