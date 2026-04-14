module top_module(
	 input [3:0] in_data1,
    input [3:0] in_data2,
    output [3:0] out_data,
    output cy
    );wire [4:0]rslt;
	 
	 assign rslt = in_data1+in_data2,
			  cy = rslt[4],
			  out_data = rslt[3:0];

endmodule