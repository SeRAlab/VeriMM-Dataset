module top_module(input D, input nCLK, input nSR, output reg nQ);parameter [0:0] INIT = 1'bx; 
  parameter[0:0] SRMODE = 1'bx; 
  initial nQ = INIT; 
  always @(*) begin 
  if(!nSR) 
  nQ <= ~SRMODE; 
  else if(!nCLK) 
  nQ <= ~D; 
  end 
 endmodule