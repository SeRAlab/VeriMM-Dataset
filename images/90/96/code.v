module top_module(count,ready,led);input [3:0]count;
input ready;
output reg [6:0]led;
always @ (*)
begin
	if(ready==1)
	begin
	case(count)
		4'b1111:led=7'b0001110;
		4'b1110:led=7'b0000110;
		4'b1101:led=7'b0100001;
		4'b1100:led=7'b1000110;
		4'b1011:led=7'b0000011;
		4'b1010:led=7'b0001000;
		4'b1001:led=7'b0010000;
		4'b1000:led=7'b0000000;
		4'b0111:led=7'b1111000;
		4'b0110:led=7'b0000010;
		4'b0101:led=7'b0010010;
		4'b0100:led=7'b0011001;
		4'b0011:led=7'b0110000;
		4'b0010:led=7'b0100100;
		4'b0001:led=7'b1111001;
		4'b0000:led=7'b1000000;
		default:led=7'b1000000;
	endcase
	end
	else
		led=7'b1111111;
end
endmodule