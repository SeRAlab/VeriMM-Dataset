module top_module(
input clk,rst_n,
input [11:0]ADDR,
input RD,WR,
inout [15:0]DATA,

output cs0,cs1,cs2,cs3,


input [15:0]rddat0,rddat1,rddat2,rddat3,rddat4,rddat5,
output reg [15:0] wrdat
);assign cs0=(ADDR[11:8]==4'd0);
assign cs1=(ADDR[11:8]==4'd1);
assign cs2=(ADDR[11:8]==4'd2);
assign cs3=(ADDR[11:8]==4'd3);


reg [15:0]rdmux;
always @(posedge clk)
	case(ADDR[11:8])
	4'd0:rdmux<=rddat0;
	4'd1:rdmux<=rddat1;
	4'd2:rdmux<=rddat2;
	4'd3:rdmux<=rddat3;
	4'd4:rdmux<=rddat4;
	4'd5:rdmux<=rddat5;
	default:;
	endcase










always @(posedge WR)
	if(WR)
	wrdat <= DATA;


assign DATA = RD? rdmux : 16'hzzzz;


endmodule