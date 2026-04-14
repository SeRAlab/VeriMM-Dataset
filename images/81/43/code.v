module register(
	input clk,
	input clear,
	input load,
	input [7:0] d,
	output reg [7:0] q);always @(posedge clk) begin
		if (clear)
			q <= 8'b00000000;
		else if (load)
			q <= d;
	end
	
endmodule