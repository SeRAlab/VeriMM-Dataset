module top_module(
	input[1:0] sel,
	input[31:0] ALUO_W,
	input[31:0] RD_W,
	input[31:0] PC8_W,
	output[31:0] datao
    );function[31:0] res;
		input[1:0] sel;
		input[31:0] ALUO_W;
		input[31:0] RD_W;
		input[31:0] PC8_W;
		case(sel)
			2'b00: res=ALUO_W;
			2'b01: res=RD_W;
			2'b10: res=PC8_W;
			default: res=0;
		endcase
	endfunction
	
	assign datao = res(sel,ALUO_W,RD_W,PC8_W);endmodule