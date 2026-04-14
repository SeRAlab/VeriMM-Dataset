module top_module(IN, IN_B, OUT);parameter TRUE_INP = 0; 
  parameter COMP_INP = 0; 
  input [TRUE_INP-1:0] IN; 
  input [COMP_INP-1:0] IN_B; 
  output reg OUT; 
  integer i; 
  always @(*) begin 
  OUT = 1; 
  for (i = 0; i < TRUE_INP; i=i+1) 
  OUT = OUT & IN[i]; 
  for (i = 0; i < COMP_INP; i=i+1) 
  OUT = OUT & ~IN_B[i]; 
  end 
 endmodule