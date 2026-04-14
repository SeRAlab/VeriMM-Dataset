module top_module (
	input clk,
	input load,
	input [7:0] load_value,
	output reg [7:0] count);

	always @(posedge clk) begin
		if (load) begin
			count <= load_value;
		end else begin
			count <= count + 1;
		end
	end
endmodule