module top_module( input shift,
				input in,
                                output out );assign out = in <<< shift;

endmodule