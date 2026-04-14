module gray_converter(bin_in, gray_out);
input [3:0] bin_in;
output [3:0] gray_out;

assign gray_out[3] = bin_in[3];
assign gray_out[2] = bin_in[3] ^ bin_in[2];
assign gray_out[1] = bin_in[2] ^ bin_in[1];
assign gray_out[0] = bin_in[1] ^ bin_in[0];

endmodule