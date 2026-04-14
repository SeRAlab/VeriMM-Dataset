module top_module(Clock, Enable,Data0,Q0);input Clock, Enable; 
 input Data0; 
 output reg Q0; 
 always @(posedge Clock) 
  if (Enable) 
  Q0 <= Data0; 
 endmodule