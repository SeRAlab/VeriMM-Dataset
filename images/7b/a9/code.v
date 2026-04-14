module top_module(x,s0,s1,y0,y1,y2,y3);input x; 
 input s0; 
 input s1; 
 output y0; 
 reg y0; 
 output y1; 
 reg y1; 
 output y2; 
 reg y2; 
 output y3; 
 reg y3; 
 always @(x, s1, s0) begin: DEMUX1_4_B_LOGIC 
  if (((s0 == 0) && (s1 == 0))) begin 
  y0 = x; 
  y1 = 0; 
  y2 = 0; 
  y3 = 0; 
  end 
  else if (((s0 == 1) && (s1 == 0))) begin 
  y0 = 0; 
  y1 = x; 
  y2 = 0; 
  y3 = 0; 
  end 
  else if (((s0 == 0) && (s1 == 1))) begin 
  y0 = 0; 
  y1 = 0; 
  y2 = x; 
  y3 = 0; 
  end 
  else begin 
  y0 = 0; 
  y1 = 0; 
  y2 = 0; 
  y3 = x; 
  end 
 end 
 endmodule