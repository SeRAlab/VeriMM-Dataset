module top_module(
		input [1:0] inA, 
		input [1:0] inB,
		input selector,

		output reg [1:0] result
	);always @(*) begin
		if(selector == 0)
				result <=inA;
			else
				result <= inB;
		end
	endmodule