module top_module(
	input[1:0] sel,
	input[31:0] MFALUBEO,
	input[31:0] EXT_E,
	output[31:0] datao
    );function[31:0] res;
		input[1:0] sel;
		input[31:0] MFALUBEO;
		input[31:0] EXT_E;
		case(sel)
			2'b00: res=MFALUBEO;
			2'b01: res=EXT_E;
			default: res=0;
		endcase
	endfunction
		 
	assign datao =  res(sel,MFALUBEO,EXT_E);endmodule