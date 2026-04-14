module top_module( op, code, out );input [1:0] op;
input [5:0] code;
output [3:0] out;

	assign out = ctrl( {op, code} );

	function [3:0] ctrl;
	input [7:0] in;
	begin
		casex (in)
			8'b1xxx0000 : ctrl = 4'b0010;
			8'b1xxx0010 : ctrl = 4'b0110;
			8'b1xxx0100 : ctrl = 4'b0000;
			8'b1xxx0101 : ctrl = 4'b0001;
			8'b1xxx1010 : ctrl = 4'b0111;
			8'b00xxxxxx : ctrl = 4'b0010;
			8'bx1xxxxxx : ctrl = 4'b0110;
			default : ctrl = 4'b0000;
		endcase
	end
	endfunction

endmodule