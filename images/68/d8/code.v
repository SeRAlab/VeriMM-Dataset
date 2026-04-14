module top_module(input D, input nCLK, output reg Q);parameter [0:0] INIT = 1'bx; 
  initial Q = INIT; 
  always @(*) begin 
  if(!nCLK) 
  Q <= D; 
  end 
 endmodule