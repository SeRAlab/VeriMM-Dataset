module top_module(
		input wire		[ 7 : 0]	pc,
		output reg		[15 : 0]	instruction
    );always @(pc) begin
		case(pc)
			8'h00:	instruction = 16'h7f00;	
			8'h01:	instruction = 16'h0100;	
			8'h02:	instruction = 16'h0101;	
			8'h03:	instruction = 16'h7200;	
			8'h04:	instruction = 16'h74ff;	
			8'h05:	instruction = 16'h0a0c;	
			8'h06:	instruction = 16'h0101;	
			8'h07:	instruction = 16'h0000;	
			8'h08:	instruction = 16'h0100;	
			8'h09:	instruction = 16'h01ff;	
			8'h0a:	instruction = 16'h0201;	
			8'h0b:	instruction = 16'h0303;	
			8'h0c:	instruction = 16'h030c;	
			default:
				begin
					instruction = 16'hffff;	
				end
		endcase
	end

endmodule