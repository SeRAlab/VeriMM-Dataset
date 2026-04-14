module top_module(
    input NPCsrc,
    input [31:0] PC4,
    input [25:0] I26,
    output [31:0] NPC
    );assign NPC = (NPCsrc==1) ? {PC4[31:28],I26[25:0],2'b00} : (PC4 + {{14{I26[15]}},I26[15:0],2'b00});
	 
endmodule