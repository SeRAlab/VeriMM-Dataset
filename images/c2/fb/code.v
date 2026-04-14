module shift_add_xor(
	input [31:0] in,
	output [63:0] out
);

	parameter KEY = 64'h0123456789ABCDEF;

	reg [63:0] shifted_input;
	reg [63:0] result;

	always @(*) begin
		shifted_input = {in, 4'b0000};
		result = shifted_input + 64'h12345678;
		result = result ^ KEY;
	end

	assign out = result;

endmodule