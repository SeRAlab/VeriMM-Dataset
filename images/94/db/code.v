module top_module(out, A, B);input logic signed [15:0] A, B;
	output logic signed [15:0] out;

	logic signed [31:0] temp;

	assign temp = A * B;
	assign out = temp[30:15];
endmodule