module top_module(input D, input nCLK, input nRST, output reg nQ);parameter [0:0] INIT = 1'bx; 
  initial nQ = INIT; 
  always @(*) begin 
  if(!nRST) 
  nQ <= 1'b1; 
  else if(!nCLK) 
  nQ <= ~D; 
  end 
 endmodule