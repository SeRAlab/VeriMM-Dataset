module top_module(
input RE, input WE, output RW,
output mem_OE, output mem_WE, output mem_CE, output mem_ADV, output mem_WAIT, output mem_UB, output mem_LB, output mem_CRE);assign RW = WE;
	
	assign mem_OE   = ~RE;
	assign mem_WE	 = ~WE;
	assign mem_CE   = ~(RE|WE);
	
	assign mem_ADV  = 1'b0;
	assign mem_WAIT = 1'b0;
	assign mem_UB   = 1'b0;
	assign mem_LB   = 1'b0;
	assign mem_CRE  = 1'b0;
	
endmodule