module top_module(
	input [15:0] data,
	output reg [15:0] light
);always @(*) begin
		light <= data;
	end
endmodule