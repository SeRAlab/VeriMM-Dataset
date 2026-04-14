module top_module(out,a,b);input [3:0]a,b;
output [7:0]out;
wire [7:0]out0,out1,out2,out3;
wire [3:0]temp0,temp1,temp2,temp3;

assign temp0 = (b[0])? a:4'b0000;
assign temp1 = (b[1])? a:4'b0000;
assign temp2 = (b[2])? a:4'b0000; 
assign temp3 = (b[3])? a:4'b0000; 
   

assign out0 = {4'b0000,temp0};
assign out1 = {3'b000,temp1,1'b0};
assign out2 = {2'b00,temp2,2'b00};
assign out3 = {1'b0,temp3,3'b000};

assign out = out0 + out1 + out2 + out3;endmodule