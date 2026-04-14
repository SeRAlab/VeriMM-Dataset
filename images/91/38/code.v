module top_module( clock_in,address,writeData,memWrite,memRead,readData);input clock_in; 
  input [31:0] address; 
  input [31:0] writeData; 
  input memWrite; 
  input memRead; 
  output [31:0] readData; 
  reg [31:0] memFile[0:127]; 
  reg [31:0] readData; 
  integer i; 
  initial 
  begin 
  for(i = 0; i < 32; i = i + 1) 
  memFile[i] = 0; 
  readData = 0; 
  end 
  always @ (memRead or address) 
  begin 
  readData = memFile[address]; 
  end 
  always @ (negedge clock_in) 
  begin 
  if(memWrite) 
  memFile[address] = writeData; 
  end 
 endmodule