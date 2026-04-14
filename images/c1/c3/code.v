module alu_bit_select(
	bsel,
	bs_out_high,
	bs_out_low
);
input wire	[2:0] bsel;
output wire	[3:0] bs_out_high;
output wire	[3:0] bs_out_low;
wire	[3:0] bs_out_high_ALTERA_SYNTHESIZED;
wire	[3:0] bs_out_low_ALTERA_SYNTHESIZED;
wire	SYNTHESIZED_WIRE_12;
wire	SYNTHESIZED_WIRE_13;
wire	SYNTHESIZED_WIRE_14;
assign	bs_out_low_ALTERA_SYNTHESIZED[0] = SYNTHESIZED_WIRE_12 & SYNTHESIZED_WIRE_13 & SYNTHESIZED_WIRE_14;
assign	bs_out_low_ALTERA_SYNTHESIZED[1] = bsel[0] & SYNTHESIZED_WIRE_13 & SYNTHESIZED_WIRE_14;
assign	bs_out_low_ALTERA_SYNTHESIZED[2] = SYNTHESIZED_WIRE_12 & bsel[1] & SYNTHESIZED_WIRE_14;
assign	bs_out_low_ALTERA_SYNTHESIZED[3] = bsel[0] & bsel[1] & SYNTHESIZED_WIRE_14;
assign	bs_out_high_ALTERA_SYNTHESIZED[0] = SYNTHESIZED_WIRE_12 & SYNTHESIZED_WIRE_13 & bsel[2];
assign	bs_out_high_ALTERA_SYNTHESIZED[1] = bsel[0] & SYNTHESIZED_WIRE_13 & bsel[2];
assign	bs_out_high_ALTERA_SYNTHESIZED[2] = SYNTHESIZED_WIRE_12 & bsel[1] & bsel[2];
assign	bs_out_high_ALTERA_SYNTHESIZED[3] = bsel[0] & bsel[1] & bsel[2];
assign	SYNTHESIZED_WIRE_12 =  ~bsel[0];
assign	SYNTHESIZED_WIRE_13 =  ~bsel[1];
assign	SYNTHESIZED_WIRE_14 =  ~bsel[2];
assign	bs_out_high = bs_out_high_ALTERA_SYNTHESIZED;
assign	bs_out_low = bs_out_low_ALTERA_SYNTHESIZED;
endmodule