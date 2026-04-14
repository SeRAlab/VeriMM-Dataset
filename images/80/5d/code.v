module top_module(input D, input nCLK, input nSET, output reg nQ);parameter [0:0] INIT = 1'bx; 
  initial nQ = INIT; 
  always @(*) begin 
  if(!nSET) 
  nQ <= 1'b0; 
  else if(!nCLK) 
  nQ <= ~D; 
  end 
 endmodule