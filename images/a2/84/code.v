module top_module(clk,progIn,progNum);parameter PROG_NUM_SIZE=8; 
 parameter WAIT_TIME=256; 
 input [PROG_NUM_SIZE-1:0] progIn; 
 input clk; 
 reg [PROG_NUM_SIZE-1:0] progInReg, progNumReg; 
 reg [14:0] timer; 
 output [PROG_NUM_SIZE-1:0] progNum; 
 initial begin 
  #0 
  progInReg=1'b0; 
  progNumReg=1'b0; 
  timer=1'b0; 
 end 
 always @(posedge clk) begin 
  if( progIn!=progInReg ) begin 
  progInReg=progIn; 
  timer=1'b0; 
  end 
  if(timer<(WAIT_TIME-1)) begin 
  timer=timer+1'b1; 
  end else begin 
  progNumReg=progInReg; 
  end 
 end 
 assign progNum=progNumReg; 
 endmodule