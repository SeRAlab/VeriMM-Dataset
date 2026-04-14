module top_module(in_data1,in_data2,in_data3,in_data4,out_data,sel);input [15:0] in_data1,in_data2,in_data3,in_data4;
input [1:0] sel;
output reg [15:0] out_data;

always @(sel,in_data1,in_data2,in_data3,in_data4)
begin
case(sel)
2'b00:out_data=in_data1;
2'b01:out_data=in_data2;
2'b10:out_data=in_data3;
2'b11:out_data=in_data4;
default:out_data=16'b0;
endcase
end
endmodule