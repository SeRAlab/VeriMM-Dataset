module top_module(clk, enable);parameter n = 15;

	input clk, enable;

	reg	[n:0]	mem_address;			

	always @(posedge clk) begin
		if(enable) begin 
			mem_address <= mem_address + 1;
		end  
	end
	
endmodule