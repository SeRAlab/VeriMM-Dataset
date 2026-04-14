module top_module( 
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);wire [3:0] nor_in;
wire nor_out_and, nor_out_or, nor_out_xor;

assign nor_in = ~in;

assign nor_out_and = ~(nor_in[0] | nor_in[1] | nor_in[2] | nor_in[3]);
assign nor_out_or = ~(nor_in[0] & nor_in[1] & nor_in[2] & nor_in[3]);
assign nor_out_xor = ~(nor_in[0] ^ nor_in[1] ^ nor_in[2] ^ nor_in[3]);

assign out_and = ~nor_out_and;
assign out_or = ~nor_out_or;
assign out_xor = ~nor_out_xor;

endmodule