module top_module(out, s, in1, in2);input s;
	input [31:0] in1;
	input [31:0] in2;

	output [31:0] out;

	wire s;
	wire [31:0] in1;
	wire [31:0] in2;

	reg [31:0] out;

	always @ (s or in1 or in2) begin
	
		if (s)
			out <= in2;
		else
			out <= in1;
	end

endmodule