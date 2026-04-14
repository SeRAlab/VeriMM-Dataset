module top_module(
    input clk,
    input [31:0] instr_F,
    input Stall_D,
    input PCSrc_D,
    input [31:0] npc_F,
    output reg [31:0] instr_D,
    output reg[31:0] npc_D,
	 input reset
    );always @ (posedge clk)
		begin
			if(reset)
			begin
				instr_D<=0;
				npc_D<=0;
			end
			else if(Stall_D)
			begin
				instr_D<=instr_D;
				npc_D<=npc_D;
			end
			else
			begin
				instr_D<=instr_F;
				npc_D<=npc_F;
			end
		end
endmodule