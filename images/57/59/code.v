module top_module( 
					input wire signed  [31:0] PC,
					input wire signed  [31:0] Imm,
					output wire signed [31:0] PCimm
					);assign PCimm = PC + Imm;
endmodule