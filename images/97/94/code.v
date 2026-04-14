module top_module(CLOCK_50,xpositionW,xpositionG,ypositionW,ypositionG,gameover);input CLOCK_50;
input [7:0]xpositionW,xpositionG;
input [6:0]ypositionW,ypositionG;
output reg gameover;

always@(posedge CLOCK_50)
if (xpositionW==xpositionG&&ypositionW==ypositionG)
gameover=1'b1;
else
gameover=1'b0;endmodule