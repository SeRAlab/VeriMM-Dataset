module top_module(
	input [3:0] bcd1,bcd2,
	output reg [3:0] in2,in3,
	output [3:0] in0,in1
    );integer d1,d2,tatol;

assign in0=bcd1;
assign in1=bcd2;

always@(*) begin
d1=bcd1[3]*8+bcd1[2]*4+bcd1[1]*2+bcd1[0];
d2=bcd2[3]*8+bcd2[2]*4+bcd2[1]*2+bcd2[0];
tatol=d1+d2;
case(tatol)
0:begin in2=4'b0000; in3=4'b0000;end
1:begin in2=4'b0000; in3=4'b0001;end
2:begin in2=4'b0000; in3=4'b0010;end
3:begin in2=4'b0000; in3=4'b0011;end
4:begin in2=4'b0000; in3=4'b0100;end
5:begin in2=4'b0000; in3=4'b0101;end
6:begin in2=4'b0000; in3=4'b0110;end
7:begin in2=4'b0000; in3=4'b0111;end
8:begin in2=4'b0000; in3=4'b1000;end
9:begin in2=4'b0000; in3=4'b1001;end
10:begin in2=4'b0001; in3=4'b0000;end
11:begin in2=4'b0001; in3=4'b0001;end
12:begin in2=4'b0001; in3=4'b0010;end
13:begin in2=4'b0001; in3=4'b0011;end
14:begin in2=4'b0001; in3=4'b0100;end
15:begin in2=4'b0001; in3=4'b0101;end
16:begin in2=4'b0001; in3=4'b0110;end
17:begin in2=4'b0001; in3=4'b0111;end
18:begin in2=4'b0001; in3=4'b1000;end
endcase
end


endmodule