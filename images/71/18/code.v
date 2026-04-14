module top_module(inAddr,outAddr);input[31:0] inAddr;
  output[31:0] outAddr;
  
  assign outAddr=inAddr+4;
  
endmodule