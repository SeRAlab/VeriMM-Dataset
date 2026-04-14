module top_module(
input	[15:0]md,		
input	zero,
input	double,
input	negation,
output	[16:0]pp 
);wire	[15:0]nmd;
assign	nmd=negation?~md:md;

wire	[15:0]zmd;
assign	zmd=zero?0:nmd;

assign	pp=double?{~zmd[15],zmd[14:0],negation}:{~zmd[15],zmd[15:0]};endmodule