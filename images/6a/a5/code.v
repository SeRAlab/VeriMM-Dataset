module top_module(clk, OPCODE);input clk;
	output reg [3:0] OPCODE;
	
	reg [2:0] state;
	
	always @(posedge clk) begin
		case(state)
			0: begin OPCODE<=4'b0011; state<=1; end
			1: begin OPCODE<=4'b0000; state<=3; end
			2: begin OPCODE<=4'b0001; state<=4; end
			3: begin OPCODE<=4'b0111; state<=5; end
			4: begin OPCODE<=4'b1000; state<=6; end
			5: begin OPCODE<=4'b1010; state<=7; end
			6: begin OPCODE<=4'b1110; state<=8; end
			7: begin OPCODE<=4'b1111; state<=0; end
			default: begin state<=0; OPCODE<=4'b0000; end
		endcase
	end
endmodule