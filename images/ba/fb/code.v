module top_module(A, B, Subtract, Result, Overflow);input [3:0] A, B;
	input Subtract;
	output [3:0] Result;
	output Overflow;

	wire [4:0] temp;
	wire carry;

	assign temp = Subtract ? A - B : A + B;
	assign Result = temp[3:0];
	assign Overflow = temp[4];

endmodule