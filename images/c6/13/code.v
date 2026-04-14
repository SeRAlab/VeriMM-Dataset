module adder_subtractor (
	input [3:0] A,
	input [3:0] B,
	input subtract,
	output reg [3:0] result
);

	always @(*) begin
		if (subtract == 1) begin
			result <= A - B;
		end else begin
			result <= A + B;
		end
	end

endmodule