module top_module(
	input [31:0]pc,
	output wire [31:0]npc
);assign npc=pc+1;
endmodule