module top_module(
	data0_i,
	data1_i,
	ALUCtrl_i,
	data_o
);input	[31:0]	data0_i;
input	[31:0]	data1_i;
input	[2:0]	ALUCtrl_i;
output	[31:0]	data_o;

wire    		[31:0]  add_o, sub_o, and_o, or_o;
wire 	signed  [63:0]  mul_o;

assign  and_o = data0_i & data1_i;
assign  or_o  = data0_i | data1_i;
assign  add_o = data0_i + data1_i;
assign  sub_o = data0_i - data1_i;
assign  mul_o = data0_i * data1_i;

assign  data_o = (ALUCtrl_i == 3'b000 ) ? and_o :
				 (ALUCtrl_i == 3'b001 ) ? or_o :
				 (ALUCtrl_i == 3'b010 ) ? add_o :
				 (ALUCtrl_i == 3'b110 ) ? sub_o  :
				 (ALUCtrl_i == 3'b011 ) ? mul_o[31:0] :
										  32'b0;

endmodule