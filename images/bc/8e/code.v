module counter_with_load (
	input clk,
	input rst,
	input load,
	input en,
	input [3:0] load_val,
	output reg [3:0] count);always @(posedge clk) begin
		if (rst)
			count <= 4'b0000;
		else if (load)
			count <= load_val;
		else if (en)
			count <= count + 1;
	end
	
endmodule