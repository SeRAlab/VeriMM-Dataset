module top_module(iflag,iA,oY);input iflag;
input iA;
output reg[7:0] oY;

always@(iA)
begin
	case(iA)
	    1'b0:oY=8'hff;
		1'b1:oY=8'hbf;
	endcase
end
endmodule