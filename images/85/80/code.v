module top_module(
	input[1:0] sel,
	input[31:0] pc_F,
	input[31:0] signextimm16,
	input[31:0] grf_rs,
	input[25:0] imm26,
	output[31:0] npc
	);reg[27:0] temp;
	reg[31:0] pc_F4;
	
	function[31:0] result;
		input[1:0] sel;
		input[31:0] pc_F;
		input[31:0] signextimm16;
		input[31:0] grf_rs;
		input[25:0] imm26;
		case(sel)
			2'b00: result=pc_F+4;
			2'b01: result=pc_F+(signextimm16<<2);
			2'b10: result=grf_rs;
			2'b11: begin temp=(imm26<<2);
						 
				   		 result={pc_F[31:28],temp};
				   end
		endcase
	endfunction

	assign npc = result(sel,pc_F,signextimm16,grf_rs,imm26);endmodule