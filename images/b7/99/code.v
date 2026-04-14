module binary_counter (
	input clk,
	input reset,
	input load,
	input [15:0] load_value,
	output reg [15:0] q);

always @(posedge clk) begin
	if (reset)
		q <= 16'b0000000000000000;
	else if (load)
		q <= load_value;
	else
		q <= q + 1;
end

endmodule