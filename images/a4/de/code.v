module top_module(
    input [7:0] a,
    input [7:0] b,
    input option,
	 output reg [7:0] selection
    );always @(a or b or option)
	begin
		selection <= option ? a : b;
	end

endmodule