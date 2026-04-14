module top_module(
	input wire [63:0]Data_A,
	input wire [63:0]Data_B,
	output reg [63:0]Result
);always @(*)
		begin
			Result <= Data_B + Data_A;
		end
endmodule