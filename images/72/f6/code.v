module top_module(
	output reg [WORD_WIDTH-1:0] INSTR_out,
	input [COUNTER_WIDTH-1:0] COUNTER_in
	);parameter WORD_WIDTH = 16;
parameter DR_WIDTH = 3;
parameter SB_WIDTH = DR_WIDTH;
parameter SA_WIDTH = DR_WIDTH;
parameter OPCODE_WIDTH = 7;
parameter CNTRL_WIDTH = DR_WIDTH+SB_WIDTH+SA_WIDTH+11;
parameter COUNTER_WIDTH = 4;

always@(COUNTER_in)
	begin
		case(COUNTER_in)
			
			16'h0000: INSTR_out = 16'b100_1100_000_000_011; 
			16'h0001: INSTR_out = 16'b100_1100_001_000_111; 
			16'h0002: INSTR_out = 16'b000_0000_010_000_XXX; 
			16'h0003: INSTR_out = 16'b000_1100_011_XXX_001; 
			16'h0004: INSTR_out = 16'b000_0010_100_000_001; 
			16'h0005: INSTR_out = 16'b000_0101_101_011_100; 
			16'h0006: INSTR_out = 16'b110_0000_000_101_011; 
			16'h0007: INSTR_out = 16'b110_0001_000_101_011; 
			16'h000A: INSTR_out = 16'b111_0000_110_000_001; 
			default: INSTR_out = 16'b0;
		endcase
	end


endmodule