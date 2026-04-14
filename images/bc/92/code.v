module top_module(VIDON,HC,VC,R,G,B,SW);input VIDON; 
 input [9:0] HC; 
 input [9:0] VC; 
 output [7:0] R; 
 output [7:0] G; 
 output [7:0] B; 
 input [17:0] SW; 
 reg [7:0] Rr, Gg, Bb; 
 assign R = Rr; 
 assign G = Gg; 
 assign B = Bb; 
 always @ (VIDON, VC) 
 begin 
  Rr <= 8'b00000000; 
  Gg <= 8'b00000000; 
  Bb <= 8'b00000000; 
  if( VIDON == 1'b1 ) 
  begin 
  Gg <= VC; 
  Rr <= HC; 
  Bb <= VC; 
  end 
 end 
 endmodule