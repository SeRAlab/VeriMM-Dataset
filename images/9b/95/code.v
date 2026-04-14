module top_module(CLK,A,DIN,DOUT,EN,WE);parameter DA_WIDTH = 11; 
  parameter DD_WIDTH = 8; 
  parameter DA_DEPTH = (1 << DA_WIDTH); 
  input CLK; 
  input [DA_WIDTH - 1:0] A; 
  input [DD_WIDTH - 1:0] DIN; 
  output reg [DD_WIDTH - 1:0] DOUT; 
  input EN; 
  input WE; 
  reg [7:0] MEM [0:DA_DEPTH - 1]; 
  always @ (posedge CLK) 
  if(EN) 
  begin 
  if(WE) 
  MEM[A] <= DIN; 
  DOUT <= MEM[A]; 
  end 
  integer i; 
  initial 
  for(i = 0; i < DA_DEPTH; i = i + 1) 
  MEM[i] = 8'b0; 
 endmodule