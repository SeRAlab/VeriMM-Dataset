module top_module(input mult, input [15:0] A, input [15:0] B, output [15:0] high, output [15:0] low);reg signed [31:0] temp;
	always @ (mult) begin
		temp = A*B;
	end
	assign high = temp[31:16];
	assign low = temp[15:0];endmodule