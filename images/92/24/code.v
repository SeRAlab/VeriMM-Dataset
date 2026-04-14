module top_module(input [7:0] iGPI,input [7:0] iGPO,input [3:0] iSSFRR,output [7:0] oSFRMX);wire [7:0] wSFRMX[7:0]; 
  assign oSFRMX = wSFRMX[iSSFRR]; 
  assign wSFRMX[0] = iGPI; 
  assign wSFRMX[1] = iGPO; 
 endmodule