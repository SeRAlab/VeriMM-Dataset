module top_module(
		input    wire			clock,
		
		input 	wire [8:0]	out_port,
		
		output	wire 			s1_reset_source,
		output	wire 			s2_reset_source,
		output	wire 			s3_reset_source,
		output	wire 			s4_reset_source,
		output	wire 			s5_reset_source,
		output	wire 			s6_reset_source,
		output	wire 			s7_reset_source,
		output	wire 			s8_reset_source
);assign s1_reset_source = out_port[1];
assign s2_reset_source = out_port[2];
assign s3_reset_source = out_port[3];
assign s4_reset_source = out_port[4];
assign s5_reset_source = out_port[5];
assign s6_reset_source = out_port[6];
assign s7_reset_source = out_port[7];
assign s8_reset_source = out_port[8];

endmodule