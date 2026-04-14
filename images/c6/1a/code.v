module arithmetic(input [7:0] a, input [7:0] b, output reg [7:0] result);

	always @(*) begin
		if(a > b)
			result = a + b;
		else if(a < b)
			result = a - b;
		else
			result = a & b;
	end

endmodule