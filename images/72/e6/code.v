module top_module(gray,binary);input [4:0] gray;
output [4:0] binary;

assign binary[4]=gray[4];
assign binary[3]=gray[3] ^ binary[4];
assign binary[2]=gray[2] ^ binary[3];
assign binary[1]=gray[1] ^ binary[2];
assign binary[0]=gray[0] ^ binary[1];

endmodule