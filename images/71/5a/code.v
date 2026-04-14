module top_module(input [6:0] A,  
		input [6:0] B,  
		input [6:0] C,
		input [6:0] D,  
		input [1:0] sel,  
		output [6:0] Y);assign Y = (sel==0) ? A : (sel==1) ? B : (sel==2) ? C : D;

endmodule