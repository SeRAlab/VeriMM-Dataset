module top_module(input D, input nCLK, output reg nQ);parameter [0:0] INIT = 1'bx; 
  initial nQ = INIT; 
  always @(*) begin 
  if(!nCLK) 
  nQ <= ~D; 
  end 
 endmodule