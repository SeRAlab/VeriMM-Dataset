module top_module (
	input clk,
	input load,
	input [1:0] load_value,
	output reg [1:0] count);

	always @(posedge clk) begin
		if (load)
			count <= load_value;
		else
			count <= count + 1;
	end
endmodule