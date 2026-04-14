module top_module(
    input [3:0] data_in,
    output reg [3:0] gray_out
);assign gray_out[0] = data_in[0];
    assign gray_out[1] = data_in[0] ^ data_in[1];
    assign gray_out[2] = data_in[1] ^ data_in[2];
    assign gray_out[3] = data_in[2] ^ data_in[3];

endmodule