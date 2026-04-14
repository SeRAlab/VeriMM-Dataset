module top_module(
	input wire [31:0]	A,
	input wire [31:0]	B,
	output reg [31:0]	add
);always @(*)
	begin
		add = A + B;
	end
endmodule