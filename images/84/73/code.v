module top_module (
	input clk,
	input rst_n,
	input load,
	input [11:0] load_val,
	output reg [11:0] count);always @(posedge clk or negedge rst_n) begin
	if (!rst_n)
		count <= 12'b000000000000;
	else if (load)
		count <= load_val;
	else
		count <= count + 1;
end

endmodule