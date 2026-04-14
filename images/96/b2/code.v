module top_module(
    input [7:0] in,
    output [15:0] out
);assign out[0] = (in == 8'h0);
    assign out[1] = (in == 8'h1);
    assign out[2] = (in == 8'h2);
    assign out[3] = (in == 8'h3);
    assign out[4] = (in == 8'h4);
    assign out[5] = (in == 8'h5);
    assign out[6] = (in == 8'h6);
    assign out[7] = (in == 8'h7);
    assign out[8] = (in == 8'h8);
    assign out[9] = (in == 8'h9);
    assign out[10] = (in == 8'ha);
    assign out[11] = (in == 8'hb);
    assign out[12] = (in == 8'hc);
    assign out[13] = (in == 8'hd);
    assign out[14] = (in == 8'he);
    assign out[15] = (in == 8'hf);

endmodule