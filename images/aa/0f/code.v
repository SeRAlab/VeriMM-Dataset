module top_module(input D, CLK, nSET, output reg nQ);parameter [0:0] INIT = 1'bx; 
  initial nQ = INIT; 
  always @(posedge CLK, negedge nSET) begin 
  if (!nSET) 
  nQ <= 1'b0; 
  else 
  nQ <= ~D; 
  end 
 endmodule