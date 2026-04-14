module top_module(input wire [31:0] dataa,
				  input wire [31:0] datab,
				  output wire [31:0] result);assign result = {dataa[31:16],datab[15:0]};

endmodule