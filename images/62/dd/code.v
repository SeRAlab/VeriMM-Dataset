module priority_encoder(
	input [2:0] in,
	output reg [1:0] out,
	output reg valid
);

	always @(*) begin
		valid = |in;
		if (in[2])
			out = 2'b10;
		else if (in[1])
			out = 2'b01;
		else if (in[0])
			out = 2'b00;
		else
			out = 2'b00;
	end

endmodule