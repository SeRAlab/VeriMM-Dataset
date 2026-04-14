module top_module(input D, CLK, nSET, output reg Q);parameter [0:0] INIT = 1'bx; 
  initial Q = INIT; 
  always @(posedge CLK, negedge nSET) begin 
  if (!nSET) 
  Q <= 1'b1; 
  else 
  Q <= D; 
  end 
 endmodule