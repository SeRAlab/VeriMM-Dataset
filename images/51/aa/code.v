module decoder4to16(
	input [3:0] in,
	input enable,
	output reg [15:0] out);

	always @(*) begin
		if (enable)
			out = 1 << in;
		else
			out = 16'b0000000000000000;
	end
	
endmodule