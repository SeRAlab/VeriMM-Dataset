module top_module(
	
	input		VGA_SYNC,
	input		VGA_BLANK,
	
	
	input [7:0] RGB_VR_o,
	input [7:0] RGB_VG_o,
	input [7:0] RGB_VB_o,
	
	output  	[7:0] AD_R_o,
	output  	[7:0] AD_G_o,
	output  	[7:0] AD_B_o
);wire 			VGA_COLORS_EN;





assign	VGA_COLORS_EN = VGA_BLANK &&(!VGA_SYNC);
assign	{AD_R_o,AD_G_o,AD_B_o} = VGA_COLORS_EN ? {RGB_VR_o,RGB_VG_o,RGB_VB_o} : {8'b0,8'b0,8'b0};










endmodule