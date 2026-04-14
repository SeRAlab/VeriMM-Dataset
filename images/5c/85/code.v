module counter3 (
	input clk,
	input reset,
	input dir,
	output reg [2:0] count
);always @(posedge clk or posedge reset) begin
	if (reset)
		count <= 3'b000;
	else if (dir)
		count <= count + 1;
	else
		count <= count - 1;
end

endmodule