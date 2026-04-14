module top_module(input [31:0] A, 
             input [31:0] B, 
				 input C0, 
				 output [31:0] S, 
				 output Co 
    );wire [32:0]c,d,e;
	assign d = {1'b0,A[31:0]};
	assign e = {C0,B[31:0]};
	assign c = d + e + C0;
	assign S = c[31:0];
	assign Co = c[32];

endmodule