module top_module(input writeEnb,clk ,input [2:0] readReg1,readReg2,writeReg , input[7:0] writeData , output wire[7:0] readData1,readData2);reg[7:0] registers[0:7]; 
  initial registers[0] = 8'b0; 
  initial registers[1] = 8'b0; 
  initial registers[2] = 8'b0; 
  initial registers[3] = 8'b0; 
  initial registers[4] = 8'b0; 
  initial registers[5] = 8'b0; 
  initial registers[6] = 8'b0; 
  initial registers[7] = 8'b0; 
  always@(posedge clk) 
  if(writeEnb && writeReg!=3'b000) 
  registers[writeReg] = writeData; 
  assign readData1 = registers[readReg1]; 
  assign readData2 = registers[readReg2]; 
 endmodule