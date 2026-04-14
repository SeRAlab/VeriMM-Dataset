module top_module( 
    input [49:0] in,
    output out_and,
    output out_or,
    output out_xor,
    output majority_out
);assign out_and = &in;
assign out_or = |in;
assign out_xor = ^in;

wire [2:0] count;
assign count[0] = &{in[0], in[1], in[2]};
assign count[1] = &{in[3], in[4], in[5], in[6], in[7]};
assign count[2] = &{in[8], in[9], in[10], in[11], in[12], in[13], in[14], in[15], in[16], in[17], in[18], in[19], in[20], in[21], in[22], in[23], in[24], in[25], in[26], in[27], in[28], in[29], in[30], in[31], in[32], in[33], in[34], in[35], in[36], in[37], in[38], in[39], in[40], in[41], in[42], in[43], in[44], in[45], in[46], in[47], in[48], in[49]};

assign majority_out = (count[2] & count[1]) | (count[2] & count[0]) | (count[1] & count[0]);

endmodule