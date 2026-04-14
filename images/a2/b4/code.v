module top_module(i,o1, o2, o3, o4, o5, o6, o7,an1, an2, an3, an4);input [2:0] i; 
  output reg o1, o2, o3, o4, o5, o6, o7; 
  output an1, an2, an3, an4; 
  always @(o1, o2, o3, o4, o5, o6, o7,i) 
  begin 
  o1 = !( (!i[0]&!i[2]) | i[1] ); 
  o2 = 1'b0; 
  o3 = !( (!i[1]) | i[0] ); 
  o4 = !( (!i[2]&!i[0]) | i[1] ); 
  o5 = !( (!i[2]&!i[0]) ); 
  o6 = !( (!i[1]&!i[0]) ); 
  o7 = !( i[2] | i[1] ); 
  end 
  assign an1 = 1'b0; 
  assign an2 = 1'b0; 
  assign an3 = 1'b0; 
  assign an4 = 1'b0; 
 endmodule