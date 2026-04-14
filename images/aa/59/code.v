module top_module(
	 input [1:0] npcsrc,
	 input [31:0] npc4,
	 input [31:0] npcb,
	 input [31:0] npcj,
	 input [31:0] npcjr,
	 output [31:0] npc
    );assign npc = npcsrc==2'b00 ? npc4 :
					  (npcsrc==2'b01 ? npcb :
					  (npcsrc==2'b10 ? npcj : npcjr));


endmodule