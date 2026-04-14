module top_module(input [1:0] i,
				output [31:0] o
				);assign o = {30'd0,i};

endmodule