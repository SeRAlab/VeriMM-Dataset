module top_module(input D, CLK, nSR, output reg Q);parameter [0:0] INIT = 1'bx; 
  parameter [0:0] SRMODE = 1'bx; 
  initial Q = INIT; 
  always @(posedge CLK, negedge nSR) begin 
  if (!nSR) 
  Q <= SRMODE; 
  else 
  Q <= D; 
  end 
 endmodule