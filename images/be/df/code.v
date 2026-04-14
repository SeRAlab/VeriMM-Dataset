module top_module(clk, reset, addr);input clk, reset;      
	
	output reg [7:0] addr; 
	
	
	
	
	
	always @(posedge clk or posedge reset)
	begin
		if (reset)
			addr <= 1'b0;
		else
			addr <= addr + 1'b1;
	end

endmodule