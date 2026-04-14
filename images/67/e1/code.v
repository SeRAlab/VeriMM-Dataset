module top_module(jal, memRe, regWe, regAddr, pcNext, memData, aluResult, writeData, writeAddr, writeEnable);input jal, memRe, regWe;
  input [3:0] regAddr;
  input [15:0] pcNext, memData, aluResult;

  output [15:0] writeData;
  output [3:0] writeAddr;
  output writeEnable;  

  assign writeData =  jal ? pcNext :
                      memRe ? memData : 
                      aluResult;

  assign writeAddr = regAddr;
  assign writeEnable = regWe;
  
endmodule