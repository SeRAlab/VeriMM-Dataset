module top_module(ReadData, WriteData, Reset,readAddress,writeAddress, Clk, writeEn,readEn);output [7 : 0] ReadData;
  input [7 : 0] WriteData;
  input [5 : 0] readAddress,writeAddress;
  input Clk  ,writeEn , readEn , Reset;
  
  reg [7 : 0] Memory [0 : 63];
  integer i;
  assign ReadData =(readEn)? Memory[readAddress]:8'bzzzzzzzz;
  
  always @(posedge Clk)
   if (Reset) begin
	for(i=0;i<64;i=i+1)
      Memory [i] = 8'b00000000;		
    end else  if (writeEn)
      Memory [writeAddress] = WriteData;
    
endmodule