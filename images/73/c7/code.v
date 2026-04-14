module top_module (
	input clk,
	input enable,
	input load,
	input [2:0] load_value,
	output reg [2:0] count);

	always @(posedge clk) begin
		if (load) begin
			count <= load_value;
		end else if (enable) begin
			count <= count + 1;
		end
	end
endmodule