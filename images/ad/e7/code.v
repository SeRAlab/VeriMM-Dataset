module top_module(input D, CLK, nRST, output reg nQ);parameter [0:0] INIT = 1'bx; 
  initial nQ = INIT; 
  always @(posedge CLK, negedge nRST) begin 
  if (!nRST) 
  nQ <= 1'b1; 
  else 
  nQ <= ~D; 
  end 
 endmodule