module top_module(
    input [7:0] in,
    output [8:0] out);wire [6:0] xor_out;
    wire carry_out;

    assign xor_out = {in[6:0]} ^ in[7];
    assign carry_out = xor_out[0] ^ xor_out[1] ^ xor_out[2] ^ xor_out[3] ^ xor_out[4] ^ xor_out[5] ^ xor_out[6];

    assign out = {in, carry_out};

endmodule