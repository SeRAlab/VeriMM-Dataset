module top_module(
	input16,
	output32
);input [15:0] input16;
	output reg [31:0] output32;
			
	always @ ( * ) begin
		output32 = input16;
		if(input16[15] == 1'b1) begin
			output32 = {16'b0000000000000000, input16};
		end
	end
endmodule