module top_module(cclk, bx, by, ptop, pbot, reset, collide);parameter px = 0; 
  parameter pw = 16; 
  input cclk; 
  input [9:0]bx; 
  input [9:0]by; 
  input [9:0]ptop; 
  input [9:0]pbot; 
  input reset; 
  output reg collide; 
  always @(posedge cclk or posedge reset) begin 
  if (cclk) begin 
  collide <= (bx >= px && bx <= (px + pw)) && (by+4 >= ptop && by-4 <= pbot); 
  end 
  else begin 
  collide <= 0; 
  end 
  end 
 endmodule