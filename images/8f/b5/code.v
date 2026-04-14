module top_module(clk,rst,if_pcplus4, stall, BJ,
	if_instr,id_pcplus4, id_instr,if_pc,id_pc
    );input clk,rst,stall, BJ;
	input wire [31:0] if_pcplus4,if_instr,if_pc;
	output reg [31:0] id_pcplus4,id_instr,id_pc;

	always @(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			id_pcplus4 <= 4;
			id_instr <= 32'b100000;
			id_pc<=0;
		end
		else if(stall | BJ)
		begin
			id_pcplus4 <= if_pcplus4;
			id_instr <= 32'b100000;
			id_pc<=if_pc;
		end
		else
		begin
			id_pcplus4 <= if_pcplus4;
			id_instr <= if_instr;
			id_pc<=if_pc;
		end
	end
endmodule