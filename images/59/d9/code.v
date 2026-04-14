module top_module(Q, C, CE, CLR, D);parameter INIT = 0; 
 localparam FLOP_DELAY = 100; 
  output Q; 
  input C, CE, CLR, D; 
  reg Q; 
  initial Q= 1'b0; 
  always @(posedge C ) 
  if (CLR) 
  Q <= 1'b0; 
  else if (CE) 
  Q <= #FLOP_DELAY D; 
 endmodule