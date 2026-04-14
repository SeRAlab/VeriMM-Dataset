module top_module(clk_400Hz,data,sm_wei,sm_duan);input clk_400Hz;
input [15:0] data;
output [3:0] sm_wei;
output [7:0] sm_duan;



reg [3:0]wei_ctrl=4'b1110;
always @(posedge clk_400Hz)
	wei_ctrl <= {wei_ctrl[2:0],wei_ctrl[3]};

reg [3:0]duan_ctrl;
always @(negedge clk_400Hz)
	case(wei_ctrl)
		4'b1110:duan_ctrl=data[3:0];
		4'b1101:duan_ctrl=data[7:4];
		4'b1011:duan_ctrl=data[11:8];
		4'b0111:duan_ctrl=data[15:12];
		default:duan_ctrl=4'hf;
	endcase


reg [7:0]duan;
always @(duan_ctrl)
	case(duan_ctrl)
	4'h0:duan=8'b1100_0000;
	4'h1:duan=8'b1111_1001;
	4'h2:duan=8'b1010_0100;
	4'h3:duan=8'b1011_0000;
	4'h4:duan=8'b1001_1001;
	4'h5:duan=8'b1001_0010;
	4'h6:duan=8'b1000_0010;
	4'h7:duan=8'b1111_1000;
	4'h8:duan=8'b1000_0000;
	4'h9:duan=8'b1001_0000;
	4'ha:duan=8'b1000_1000;
	4'hb:duan=8'b1000_0011;
	4'hc:duan=8'b1100_0110;
	4'hd:duan=8'b1010_0001;
	4'he:duan=8'b1000_0111;
	4'hf:duan=8'b1000_1110;

	default : duan = 8'b1100_0000;
	endcase

assign sm_wei = wei_ctrl;
assign sm_duan = duan;endmodule