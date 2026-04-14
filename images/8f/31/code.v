module top_module(datain,dataout0,dataout1,dataout2,dataout3,dataout4,dataout5,dataout6,dataout7,dataout8,dataout9,neural_addr,weight_addr,rd,wt,clk);input [9:0]datain;
input[3:0]neural_addr;
input[3:0]weight_addr;
input wt,rd,clk;
output reg[9:0]dataout0;
output reg[9:0]dataout1;
output reg[9:0]dataout2;
output reg[9:0]dataout3;
output reg[9:0]dataout4;
output reg[9:0]dataout5;
output reg[9:0]dataout6;
output reg[9:0]dataout7;
output reg[9:0]dataout8;
output reg[9:0]dataout9;
reg[9:0] weight[9:0][9:0];
reg[3:0]i;
always@(posedge clk)
begin
if (wt==1&&rd==0)
begin
weight[neural_addr][weight_addr]<=datain;
i=0;
end
else if (rd==1&&wt==0)
begin
if(i<10)
begin
dataout0<=weight[i][0];
dataout1<=weight[i][1];
dataout2<=weight[i][2];
dataout3<=weight[i][3];
dataout4<=weight[i][4];
dataout5<=weight[i][5];
dataout6<=weight[i][6];
dataout7<=weight[i][7];
dataout8<=weight[i][8];
dataout9<=weight[i][9];
i=i+1;
end
else
begin
i=0;
end
end
end
endmodule