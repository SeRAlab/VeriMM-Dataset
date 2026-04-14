module top_module(input D, input nCLK, input nSR, output reg Q);parameter [0:0] INIT = 1'bx; 
  parameter[0:0] SRMODE = 1'bx; 
  initial Q = INIT; 
  always @(*) begin 
  if(!nSR) 
  Q <= SRMODE; 
  else if(!nCLK) 
  Q <= D; 
  end 
 endmodule