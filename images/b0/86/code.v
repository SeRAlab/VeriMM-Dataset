module top_module(input D, CLK, nRST, output reg Q);parameter [0:0] INIT = 1'bx; 
  initial Q = INIT; 
  always @(posedge CLK, negedge nRST) begin 
  if (!nRST) 
  Q <= 1'b0; 
  else 
  Q <= D; 
  end 
 endmodule