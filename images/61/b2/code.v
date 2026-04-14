module top_module(
input [7:0] in1,
input [7:0] in2,
input [7:0] in3,
input [7:0] in4,
input [7:0] in5,
input [7:0] in6,
input [7:0] in7,
input [7:0] in8,
input [2:0] choose,
output reg [7:0] out
);always@(in1 or in2 or in3 or in4 or in5 or in6 or in7 or in8 or choose)
case(choose)
3'b000:out=in1;
3'b001:out=in2;
3'b010:out=in3;
3'b011:out=in4;
3'b100:out=in5;
3'b101:out=in6;
3'b110:out=in7;
3'b111:out=in8;
default:out=8'b0;
endcase
endmodule