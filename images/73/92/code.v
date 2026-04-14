module top_module(char0, char1, char2 , char3, state, char);input [3:0] char0, char1, char2, char3;
input [3:0] state;
output reg [3:0] char;


always@(*)begin	
	case(state)
		4'b0001: char = char3;
		4'b1101: char = char0;
		4'b1001: char = char1;
		4'b0101: char = char2;
		default: char = char;
	endcase
end

endmodule