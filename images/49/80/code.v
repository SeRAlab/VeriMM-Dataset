module top_module(output O, input I);specify
		(I => O) = 0;
	endspecify

	assign O = I;
endmodule