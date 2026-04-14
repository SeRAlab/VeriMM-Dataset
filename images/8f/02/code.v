module top_module(
	input [5:0]instruction,
	input [15:0] data_in_A,
	input [15:0] data_in_B,
	output [15:0] data_out
    );parameter MOVE = 6'd5, NOT = 6'd6, AND = 6'd7, OR = 6'd8, SHIFTR = 6'd9, SHIFTL = 6'd10;
	parameter ADD = 6'd11, SUB = 6'd12, TEST = 6'd13;
	
	
	
	
	
	assign data_out = instruction == MOVE ? data_in_B:
							instruction == NOT ? ~data_in_A:
							instruction == AND ? data_in_A & data_in_B:
							instruction == OR ? data_in_A | data_in_B:
							instruction == SHIFTR ? {1'b0,data_in_A[15:1]} :












								
								
								
							instruction == SHIFTL ? {data_in_A[14:0],1'b0} :















							instruction == ADD ? data_in_A + data_in_B:  data_in_A - data_in_B;
endmodule