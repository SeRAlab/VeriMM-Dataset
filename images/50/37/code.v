module top_module(input CLK,input RESETn,input signalMask,input signalIn,input requestWR,input requestIn,output reg requestOut);wire request = requestWR ? requestIn : 
  (signalMask & signalIn | requestOut); 
  always @ (posedge CLK) 
  if(~RESETn) 
  requestOut <= 1'b0; 
  else 
  requestOut <= request; 
 endmodule