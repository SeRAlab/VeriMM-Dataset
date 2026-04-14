module top_module(
        input in1_i,
        input in2_i,
        input in3_i,
        output out_o
    );assign out_o = in1_i & in2_i & in3_i;
endmodule