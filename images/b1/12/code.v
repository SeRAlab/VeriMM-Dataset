module top_module(clock,reset,position,enable,ld_x,ld_y,ld_c,color_in,color_out,x_out,y_out);input clock;
input reset;
input enable;
input ld_x,ld_y,ld_c;
input [6:0] position;
input [2:0] color_in;
output [7:0] x_out;
output [6:0] y_out;
output [2:0] color_out;

reg [7:0] x;
reg [6:0] y;
reg [2:0] color;
reg [3:0] index;
reg stop;

always @(posedge clock)
begin
if(!reset)
begin
x <= 8'b00000000;
y <= 7'b0000000;
color <= 3'b000;
end
else
begin
if(ld_x)   
x <= {1'b0, position};
if(ld_y)   
y <= position;
if(ld_c)   
color <= color_in;
end
end


always @(posedge clock)
begin
if(!reset)
index[3:0] <= 4'b0000;
else if(enable)
begin
if(index[3:0] == 4'b1111)
index[3:0] = 4'b0000;
else
index = index + 1'b1;
end
end

assign x_out = x + index[1:0];
assign y_out = y + index[3:2];
assign color_out = color;endmodule