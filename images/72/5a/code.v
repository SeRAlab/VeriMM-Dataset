module top_module();reg clock=0;

	wire clk;
	
	assign clk = clock;
	
	always	begin
		#10	clock = ~ clk;
	end

endmodule