module top_module(
	ID_EX_MEMR_i,
	RS1_i,
	RS2_i,
	ID_EX_RD_i,
	PCWrite_o,
	IF_ID_Write_o,
	BubbleSignal_o
);input       ID_EX_MEMR_i;
input [4:0] RS1_i;
input [4:0] RS2_i;
input [4:0] ID_EX_RD_i;
output      PCWrite_o;
output      IF_ID_Write_o;
output      BubbleSignal_o;

assign PCWrite_o      = (ID_EX_MEMR_i && ID_EX_RD_i != 0 && (ID_EX_RD_i == RS1_i || ID_EX_RD_i == RS2_i))? 0 : 1;
assign IF_ID_Write_o  = (ID_EX_MEMR_i && ID_EX_RD_i != 0 && (ID_EX_RD_i == RS1_i || ID_EX_RD_i == RS2_i))? 0 : 1;
assign BubbleSignal_o = (ID_EX_MEMR_i && ID_EX_RD_i != 0 && (ID_EX_RD_i == RS1_i || ID_EX_RD_i == RS2_i))? 1 : 0;

endmodule