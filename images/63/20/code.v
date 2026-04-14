module top_module(
	input A,
	input B,
	output reg C
);always @*
begin
	C = A & B;
end

endmodule