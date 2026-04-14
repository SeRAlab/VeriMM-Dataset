module top_module(Din0,Din1,Din2,Din3,Din4,Din5,Din6,Din7,Din8,Din9,Din10,Din11,Din12,Din13,Din14,Din15,Dout);input [7:0] Din0;
input [7:0] Din1;
input [7:0] Din2;
input [7:0] Din3;
input [7:0] Din4;
input [7:0] Din5;
input [7:0] Din6;
input [7:0] Din7;
input [7:0] Din8;
input [7:0] Din9;
input [7:0] Din10;
input [7:0] Din11;
input [7:0] Din12;
input [7:0] Din13;
input [7:0] Din14;
input [7:0] Din15;
output [127:0] Dout;

wire [127:0] b0;

assign Dout = b0;

assign b0[127:120] = Din15[7:0];
assign b0[119:112] = Din14[7:0];
assign b0[111:104] = Din13[7:0];
assign b0[103:96] = Din12[7:0];
assign b0[95:88] = Din11[7:0];
assign b0[87:80] = Din10[7:0];
assign b0[79:72] = Din9[7:0];
assign b0[71:64] = Din8[7:0];
assign b0[63:56] = Din7[7:0];
assign b0[55:48] = Din6[7:0];
assign b0[47:40] = Din5[7:0];
assign b0[39:32] = Din4[7:0];
assign b0[31:24] = Din3[7:0];
assign b0[23:16] = Din2[7:0];
assign b0[15:8] = Din1[7:0];
assign b0[7:0] = Din0[7:0];

endmodule