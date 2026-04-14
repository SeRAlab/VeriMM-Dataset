module top_module(output reg Q, input D, CLK, CE, RESET);parameter [0:0] INIT = 1'b0; 
  initial Q = INIT; 
  always @(posedge CLK) begin 
  if (RESET) 
  Q <= 1'b0; 
  else if (CE) 
  Q <= D; 
  end 
 endmodule