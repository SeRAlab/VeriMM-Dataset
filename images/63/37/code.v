module top_module(in,select,out0,out1,out2,out3);input [7:0]in;
input [1:0]select;

output reg [7:0]out0;
output reg [7:0]out1;
output reg [7:0]out2;
output reg [7:0]out3;

always@*
begin
case(select)
2'b00:begin
out0=in;
out1=8'b00000000;
out2=8'b00000000;
out3=8'b00000000;
	end
2'b01:
begin
out0=8'b00000000;
out1=in;
out2=8'b00000000;
out3=8'b00000000;
end
2'b10:
begin
out0=8'b00000000;
out1=8'b00000000;
out2=in;
out3=8'b00000000;
end
2'b11:
begin
out0=8'b00000000;
out1=8'b00000000;
out2=8'b00000000;
out3=in;
end
endcase
end
endmodule