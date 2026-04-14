module top_module (
	input clk,
	output reg [4:0] count);

	always @(posedge clk) begin
		count <= {~count[0], count[4:1]};
	end
endmodule