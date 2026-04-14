module binary_counter(
	input clk,
	input reset,
	input load,
	input [7:0] load_value,
	output reg [7:0] count);always @(posedge clk) begin
		if (reset)
			count <= 8'b00000000;
		else if (load)
			count <= load_value;
		else
			count <= count + 1;
	end
	
endmodule