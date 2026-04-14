module top_module(in,out1,out2);input [7:0] in;
output reg [6:0]out1;
output reg [6:0]out2;
always @(in)
begin
	case(in/10)
		0:out1=7'b1000000;
		1:out1=7'b1111001;
		2:out1=7'b0100100;
		3:out1=7'b0110000;
		4:out1=7'b0011001;
		5:out1=7'b0010010;
		6:out1=7'b0000010;
		7:out1=7'b1111000;
		8:out1=7'b0000000;
		9:out1=7'b0010000;
		default:out1=7'b1111111;
	endcase
	case(in%10)
		0:out2=7'b1000000;
		1:out2=7'b1111001;
		2:out2=7'b0100100;
		3:out2=7'b0110000;
		4:out2=7'b0011001;
		5:out2=7'b0010010;
		6:out2=7'b0000010;
		7:out2=7'b1111000;
		8:out2=7'b0000000;
		9:out2=7'b0010000;
		default:out2=7'b1111111;
	endcase
end
endmodule