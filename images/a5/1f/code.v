module top_module(
	input wire [31:0] instruction_fetch,
	input wire [31:0] PC_fetch,
	input wire clock,
	
	output reg [31:0] instruction_decode,
	output reg [31:0] PC_decode);always @(posedge clock) begin
		instruction_decode <= instruction_fetch;
		PC_decode <= PC_fetch;
	end
endmodule