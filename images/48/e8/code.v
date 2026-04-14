module top_module(
	input [255:0] array1,
	input [255:0] array2,
	output [31:0] res
);wire [31:0] mul_0;
wire [31:0] mul_1;
wire [31:0] mul_2;
wire [31:0] mul_3;
wire [31:0] mul_4;
wire [31:0] mul_5;
wire [31:0] mul_6;
wire [31:0] mul_7;

wire [31:0] add_0;
wire [31:0] add_1;
wire [31:0] add_2;
wire [31:0] add_3;


wire [31:0] add_1_0;
wire [31:0] add_1_1;


assign mul_0 = array1[31:0]*array2[31:0];
assign mul_1 = array1[63:32]*array2[63:32];
assign mul_2 = array1[95:64]*array2[95:64];
assign mul_3 = array1[127:96]*array2[127:96];
assign mul_4 = array1[159:128]*array2[159:128];
assign mul_5 = array1[191:160]*array2[191:160];
assign mul_6 = array1[223:192]*array2[223:192];
assign mul_7 = array1[255:224]*array2[255:224];

assign add_0 = mul_0 + mul_1;
assign add_1 = mul_2 + mul_3;
assign add_2 = mul_4 + mul_5;
assign add_3 = mul_6 + mul_7;


assign add_1_0 = add_0 + add_1;
assign add_1_1 = add_2 + add_3;


assign res =  add_1_0 + add_1_1;

endmodule