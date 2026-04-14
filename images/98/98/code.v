module decoder_2to4 (
    input wire [1:0] in,
    input wire enable,
    output wire [3:0] out
);

    assign out = enable ? (4'b0001 << in) : 4'b0000;

endmodule