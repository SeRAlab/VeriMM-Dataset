module top_module(immediate, signed_ext, ext);input[15:0] immediate;
input signed_ext;
output[31:0] ext;
	assign ext = signed_ext ? {{16{immediate[15]}}, immediate[15:0]} : {{16{1'b0}}, immediate[15:0]};

endmodule