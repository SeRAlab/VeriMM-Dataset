module reverse_bits(
    input [15:0] in,
    output [15:0] out
);

genvar i;
generate
    for (i = 0; i < 16; i = i + 1) begin : reverse_loop
        assign out[i] = in[15-i];
    end
endgenerate

endmodule