module top_module(A_hex,B_hex,OP_hex,OP_dec,A_dec,B_dec);input [7:0] A_hex;
input [7:0] B_hex;
output [15:0] OP_hex;
output [15:0] OP_dec;
output [7:0] A_dec;
output [7:0] B_dec;

wire [15:0] temp1;
wire [15:0] temp2;
wire [15:0] temp3;
wire [15:0] temp4;
wire [15:0] temp5;
wire [7:0] temp6;
wire [7:0] temp7;
wire [7:0] temp8;
wire [7:0] temp9;


assign temp1 = A_hex * B_hex;
assign temp2 = temp1 % 16'd10;
assign OP_dec[3:0] = {temp2[3:0]};
assign temp3 = (temp1 % 16'd100 )/16'd10;
assign OP_dec[7:4] = {temp3[3:0]};
assign temp4 = (temp1 % 16'd1000) / 16'd100;
assign OP_dec[11:8] = {temp4[3:0]};
assign temp5 = temp1 / 16'd1000;
assign OP_dec[15:12] = {temp5[3:0]};

assign OP_hex = {temp1[15:0]};

assign temp6 = A_hex % 8'd10;
assign A_dec[3:0] = {temp6[3:0]};
assign temp7 = A_hex / 8'd10;
assign A_dec[7:4] = {temp7[3:0]};

assign temp8 = B_hex % 8'd10;
assign B_dec[3:0] = {temp8[3:0]};
assign temp9 = B_hex / 8'd10;
assign B_dec[7:4] = {temp9[3:0]};endmodule