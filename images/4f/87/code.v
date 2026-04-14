module top_module(ALUSrc, ReadData2, s_extend, res);input ALUSrc;
	input [7:0] ReadData2,s_extend;	
	
	output reg [7:0] res;
	
	always @(ALUSrc, ReadData2, s_extend) begin
		case (ALUSrc)
			0: res = ReadData2;
			1: res = s_extend;
		endcase
	end
endmodule