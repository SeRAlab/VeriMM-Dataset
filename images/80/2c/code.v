module counter20 (
	input clk,
	input reset,
	input [19:0] preset,
	output reg [19:0] count
);always @(posedge clk or posedge reset) begin
	if (reset)
		count <= preset;
	else
		count <= count + 1;
end

endmodule