module top_module( 
	data,
	q,
	zero) ;input   [1:0]  data;
	output   [0:0]  q;
	output   zero;


	assign
		q = {(~ data[0])},
		zero = (~ (data[0] | data[1]));
endmodule