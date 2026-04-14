module top_module(x,y,s,z,v);input [17:0] x,y;
input [1:0] s;
output reg[17:0] z;
output reg v;

always @(*) begin
	case (s)
	2'b00 : z=x+y;
	2'b01 : z=x-y;
	2'b10 : z=x*y;
	2'b11 : z=x/y;
	default : z=18'b0;
	endcase
	if(z<=18'd99999||z>=-18'd9999) v=1'b0;
	else v=1'b1;
end
endmodule