module top_module(input [31:0] in1,input [31:0] in2,input [31:0] in3,input [31:0] in4,input [31:0] in5,input [2:0] choose,output reg [31:0] out);always@(in1 or in2 or in3 or in4 or in5 or choose) 
 case(choose) 
 3'b000:out=in1; 
 3'b001:out=in2; 
 3'b010:out=in3; 
 3'b011:out=in4; 
 3'b100:out=in5; 
 default:out=32'b0; 
 endcase 
 endmodule