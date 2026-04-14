module top_module(C, PRE, CLR, D, Q);parameter INIT = 0; 
  input C, PRE, CLR, D; 
  output reg Q; 
  initial begin 
  Q <= INIT; 
  end 
  always @(posedge C, posedge PRE, posedge CLR) begin 
  if (CLR == 1) 
  Q <= 0; 
  else if (PRE == 1) 
  Q <= 1; 
  else 
  Q <= D; 
  end 
 endmodule