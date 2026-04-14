module top_module(
input [3:0]a,b,
output [3:0]y,y1,y2,y3,y4);assign y=a|b;
assign y1=a&b;
assign y2=~b;
assign y3=a^b;
assign y4=a^~b;
endmodule