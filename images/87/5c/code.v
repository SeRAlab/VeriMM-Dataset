module top_module(	input [9:0]A, 
						input [9:0]B, 
						input sel,
						output [9:0]out
					);assign out = (sel) ? B : A;

endmodule