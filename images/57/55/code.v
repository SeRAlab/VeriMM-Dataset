module top_module(c, r, en, q1, q2, q3);input c, r, en; 
  output [2:0] q1; 
  output [1:0] q2; 
  output [1:0] q3; 
  reg [6:0]q; 
  assign q1 = q[2:0]; 
  assign q2 = q[4:3]; 
  assign q3 = q[6:5]; 
  always @(posedge c) 
  if (r) 
  q <= 0; 
  else if (en) 
  q <= q + 1'b1; 
 endmodule