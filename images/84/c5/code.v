module top_module(clk,rst,as1,bs1,cs1,cw1,cd1,as2,bs2,cs2,cw2,cd2,AD1,BD1,CD1,WT1,AD2,BD2,CD2,WT2);input clk; 
 input rst; 
 input [2:0] as1; 
 input [2:0] bs1; 
 input [2:0] cs1; 
 input cw1; 
 input [15:0] cd1; 
 output [15:0] AD1; 
 output [15:0] BD1; 
 output [15:0] CD1; 
 output WT1; 
 input [2:0] as2; 
 input [2:0] bs2; 
 input [2:0] cs2; 
 input cw2; 
 input [15:0] cd2; 
 output [15:0] AD2; 
 output [15:0] BD2; 
 output [15:0] CD2; 
 output WT2; 
 reg [15:0] rDat [0:7]; 
 assign AD1=rDat[as1]; 
 assign AD2=rDat[as2]; 
 assign BD1=rDat[bs1]; 
 assign BD2=rDat[bs2]; 
 assign CD1=rDat[cs1]; 
 assign CD2=rDat[cs2]; 
 assign WT1=(cs1==cs2)&&cw2; 
 assign WT2=(cs1==cs2)&&cw1; 
 always@(posedge clk or posedge rst) begin 
  if(rst) begin 
  rDat[0]<=0; 
  rDat[1]<=0; 
  rDat[2]<=0; 
  rDat[3]<=0; 
  rDat[4]<=0; 
  rDat[5]<=0; 
  rDat[6]<=0; 
  rDat[7]<=0; 
  end 
  else begin 
  if(cw1&&~WT1) begin 
  rDat[cs1]<=cd1; 
  end 
  if(cw2&&~WT2) begin 
  rDat[cs2]<=cd2; 
  end 
  end 
 end 
 endmodule