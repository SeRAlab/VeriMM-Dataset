module top_module(data0,data1,data2,data3,data4,data5,selectinput,out);input [15:0] data0,data1,data2,data3,data4,data5;
input [2:0]selectinput;
output reg [15:0] out;



always @(*)
begin

case (selectinput)
0:
	out = data0;
1:
	out = data1;
2:
	out = data2;
3:
	out = data3;
4:
	out = data4;
5:
	out = data5;
default:
	out = data0;
endcase

end
	
endmodule