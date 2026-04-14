module top_module(clk, sigIn, waitCnt, sigOut);parameter WAIT_CNT_SIZE=11; 
 input clk, sigIn; 
 input [WAIT_CNT_SIZE-1:0] waitCnt; 
 output wire sigOut; 
 reg sigOutReg, sigInLast; 
 reg [WAIT_CNT_SIZE-1:0] timer; 
 initial begin 
  #0 
  sigInLast=1'b0; 
  sigOutReg=1'b0; 
  timer=1'b0; 
 end 
 always @(posedge clk) begin 
  if(sigInLast != sigIn) begin 
  timer=1'b0; 
  sigInLast=sigIn; 
  end 
  if(timer<waitCnt) begin 
  timer=timer+1'b1; 
  end else begin 
  sigOutReg=sigInLast; 
  end 
 end 
 assign sigOut=sigOutReg; 
 endmodule