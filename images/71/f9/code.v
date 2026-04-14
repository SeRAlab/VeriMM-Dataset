module top_module(res,out1);input [3:0]res;
	output reg [6:0]out1;
	always @(res)
	begin
	 case (res)
		0:out1=7'b1000000;
		1:out1=7'b1111001;
		2:out1=7'b0100100;
		3:out1=7'b0110000;
		4:out1=7'b0011001;
		5:out1=7'b0010010;
		6:out1=7'b0000010;
		7:out1=7'b1111000;
		8:out1=7'b0000000;
		9:out1=7'b0011000;
		10:out1=7'b0001000;
		11:out1=7'b0000011;
		12:out1=7'b1000110;
		13:out1=7'b0100001;
		14:out1=7'b0000110;
		15:out1=7'b0001110;
		default:out1=7'b1000000;
	  endcase
	end
endmodule