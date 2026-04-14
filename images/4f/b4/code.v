module top_module(PC4,PC8
    );input [31:0]PC4;
	 output [31:0]PC8;
	 assign PC8=PC4+4;
endmodule