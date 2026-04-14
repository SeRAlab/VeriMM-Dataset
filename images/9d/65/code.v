module top_module(inAddr_add,inAddr_sl2,outAddr);input[31:0] inAddr_add;
  input[31:0] inAddr_sl2;
  output[31:0] outAddr;
  
  assign outAddr=inAddr_add+inAddr_sl2;
   
endmodule