module top_module( 
    input [49:0] in,
    output out_and,
    output out_or,
    output out_xor,
    output majority_out
);// AND gate
    assign out_and = &in;

    // OR gate
    assign out_or = |in;

    // XOR gate
    assign out_xor = ^in;

    // Majority gate
    wire [5:0] count;
    assign count = in[5:0] + in[11:6] + in[17:12] + in[23:18] + in[29:24] + in[35:30] + in[41:36] + in[47:42];
    assign majority_out = (count >= 25);

endmodule