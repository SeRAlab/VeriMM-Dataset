module top_module(
    input [31:0] PC0,
    output reg [31:0] PC4
    );always @(PC0) begin
	     PC4 = PC0 + 4;
	 end
endmodule