module top_module(input D, input nCLK, input nRST, output reg Q);parameter [0:0] INIT = 1'bx; 
  initial Q = INIT; 
  always @(*) begin 
  if(!nRST) 
  Q <= 1'b0; 
  else if(!nCLK) 
  Q <= D; 
  end 
 endmodule