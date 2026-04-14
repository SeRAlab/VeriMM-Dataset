module top_module(input [3:0] sel,
							  input [15:0] M0,
							  input [15:0] M1,
							  input [15:0] M2,
							  input [15:0] M3,
							  input [15:0] M4,
							  input [15:0] M5,
							  input [15:0] M6,
							  input [15:0] M7,
							  input [15:0] M8,
							  input [15:0] M9,
							  input [15:0] M10,
							  input [15:0] M11,
							  input [15:0] M12,
							  input [15:0] M13,
							  input [15:0] M14,
							  input [15:0] M15,
							  output reg [15:0] OU);always @(sel or M0 or M1 or M2 or M3 or M4 or M5 or M6 or M7 or M8 or M9 or M10 or M11 or M12 or M13 or M14 or M15) begin

case(sel)
0:OU=M0;
1:OU=M1;
2:OU=M2;
3:OU=M3;
4:OU=M4;
5:OU=M5;
6:OU=M6;
7:OU=M7;
8:OU=M8;
9:OU=M9;
10:OU=M10;
11:OU=M11;
12:OU=M12;
13:OU=M13;
14:OU=M14;
15:OU=M15;
endcase


end							  

endmodule