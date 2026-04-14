module data_switch_mask(
	sw_up_en,
	sw_down_en,
	sw_mask543_en,
	db_down,
	db_up
);
input wire	sw_up_en;
input wire	sw_down_en;
input wire	sw_mask543_en;
inout wire	[7:0] db_down;
inout wire	[7:0] db_up;
wire	SYNTHESIZED_WIRE_4;
wire	[1:0] SYNTHESIZED_WIRE_1;
wire	[2:0] SYNTHESIZED_WIRE_2;
assign	SYNTHESIZED_WIRE_4 =  ~sw_mask543_en;
assign	SYNTHESIZED_WIRE_1 = db_up[7:6] & {SYNTHESIZED_WIRE_4,SYNTHESIZED_WIRE_4};
assign	db_down[7] = sw_down_en ? SYNTHESIZED_WIRE_1[1] : 1'bz;
assign	db_down[6] = sw_down_en ? SYNTHESIZED_WIRE_1[0] : 1'bz;
assign	db_down[2] = sw_down_en ? SYNTHESIZED_WIRE_2[2] : 1'bz;
assign	db_down[1] = sw_down_en ? SYNTHESIZED_WIRE_2[1] : 1'bz;
assign	db_down[0] = sw_down_en ? SYNTHESIZED_WIRE_2[0] : 1'bz;
assign	SYNTHESIZED_WIRE_2 = db_up[2:0] & {SYNTHESIZED_WIRE_4,SYNTHESIZED_WIRE_4,SYNTHESIZED_WIRE_4};
assign	db_up[7] = sw_up_en ? db_down[7] : 1'bz;
assign	db_up[6] = sw_up_en ? db_down[6] : 1'bz;
assign	db_up[5] = sw_up_en ? db_down[5] : 1'bz;
assign	db_up[4] = sw_up_en ? db_down[4] : 1'bz;
assign	db_up[3] = sw_up_en ? db_down[3] : 1'bz;
assign	db_up[2] = sw_up_en ? db_down[2] : 1'bz;
assign	db_up[1] = sw_up_en ? db_down[1] : 1'bz;
assign	db_up[0] = sw_up_en ? db_down[0] : 1'bz;
assign	db_down[5] = sw_down_en ? db_up[5] : 1'bz;
assign	db_down[4] = sw_down_en ? db_up[4] : 1'bz;
assign	db_down[3] = sw_down_en ? db_up[3] : 1'bz;
endmodule