module alu_prep_daa(
	high,
	low,
	low_gt_9,
	high_eq_9,
	high_gt_9
);
input wire	[3:0] high;
input wire	[3:0] low;
output wire	low_gt_9;
output wire	high_eq_9;
output wire	high_gt_9;
wire	SYNTHESIZED_WIRE_0;
wire	SYNTHESIZED_WIRE_1;
wire	SYNTHESIZED_WIRE_2;
wire	SYNTHESIZED_WIRE_3;
wire	SYNTHESIZED_WIRE_4;
wire	SYNTHESIZED_WIRE_5;
assign	SYNTHESIZED_WIRE_4 =  ~high[2];
assign	SYNTHESIZED_WIRE_1 = low[3] & low[2];
assign	SYNTHESIZED_WIRE_3 = high[3] & high[2];
assign	SYNTHESIZED_WIRE_0 = low[3] & low[1];
assign	low_gt_9 = SYNTHESIZED_WIRE_0 | SYNTHESIZED_WIRE_1;
assign	SYNTHESIZED_WIRE_2 = high[3] & high[1];
assign	high_gt_9 = SYNTHESIZED_WIRE_2 | SYNTHESIZED_WIRE_3;
assign	SYNTHESIZED_WIRE_5 =  ~high[1];
assign	high_eq_9 = high[3] & high[0] & SYNTHESIZED_WIRE_4 & SYNTHESIZED_WIRE_5;
endmodule