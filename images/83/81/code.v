module binary_comparator (
	input [4:0] a,
	input [4:0] b,
	output reg greater,
	output reg less,
	output reg equal);

always @(*) begin
	if (a > b) begin
		greater = 1;
		less = 0;
		equal = 0;
	end else if (a < b) begin
		greater = 0;
		less = 1;
		equal = 0;
	end else begin
		greater = 0;
		less = 0;
		equal = 1;
	end
end

endmodule