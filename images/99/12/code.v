module binary_subtractor(
	input      [3:0] A,
	input      [3:0] B,

	output reg [3:0] result,
	output reg borrow_out
);

always @(*) begin
	{borrow_out, result} = A - B;
end

endmodule