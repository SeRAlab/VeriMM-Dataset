module top_module(exp_a,exp_b,exp_c,shamt,ab_req);input [7:0] exp_a, exp_b, exp_c;
	
	
	output [7:0] shamt;
	output ab_req;
	
	assign shamt = exp_a+exp_b-exp_c;
	assign ab_req = (shamt[7] == 1 && shamt[6:0] <= 7'b1101000) ? 0 : 1;
endmodule