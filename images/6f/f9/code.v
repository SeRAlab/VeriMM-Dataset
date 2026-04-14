module top_module(
	clk,rst,stall,
	ex_aluresult, ex_td, ex_d2, ex_WREG, ex_WMEM, ex_LW,ex_instr,ex_pc,
	me_aluresult, me_td, me_d2, me_WREG, me_WMEM, me_LW,me_instr,me_pc
    );input clk,rst,stall;
	input wire [31:0] ex_aluresult,ex_d2,ex_instr,ex_pc;
	input wire [4:0] ex_td;
	input wire ex_WREG,ex_WMEM,ex_LW;
	output reg [31:0] me_aluresult,me_d2,me_instr,me_pc;
	output reg [4:0] me_td;
	output reg me_WREG,me_WMEM,me_LW;

	always @(posedge clk or posedge rst)
	begin
	if(rst)
	begin
		me_aluresult <= 0;
		me_d2 <= 0;
		me_td <= 0;
		me_WREG <= 0;
		me_WMEM <= 0;
		me_LW <= 0;
		me_instr<=32'b100000;
		me_pc <= 32'b0;
	end
	else if(stall)
	begin
			me_aluresult <= 0;
			me_d2 <= 0;
			me_td <= 0;
			me_WREG <= 0;
			me_WMEM <= 0;
			me_LW <= 0;
			me_pc <= 0;
			me_instr<=32'b100000;
			me_pc <= ex_pc;
	end
	else
	begin
		me_aluresult <= ex_aluresult;
		me_d2 <= ex_d2;
		me_td <= ex_td;
		me_WREG <= ex_WREG;
		me_WMEM <= ex_WMEM;
		me_LW <= ex_LW;
		me_instr<=ex_instr;
		me_pc <= ex_pc;
	end
	end

endmodule