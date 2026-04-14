module top_module(input [31:0] a, b, c, d, input[1:0] decider, output [31:0] choosen);assign choosen = 
		(decider == 2'd0) ? a :
		(decider == 2'd1) ? b :
		(decider == 2'd2) ? c : d;

endmodule