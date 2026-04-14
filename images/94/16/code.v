module top_module(
    input  wire bitA,
    input  wire bitB,
    input  wire bitC,
    input  wire bitD,
    output wire seg_a,
    output wire seg_b,
    output wire seg_c,
    output wire seg_d,
    output wire seg_e,
    output wire seg_f,
    output wire seg_g
);assign seg_a = (~bitA & ~bitB & ~bitC & ~bitD) | (~bitA & bitB & bitC & ~bitD);
    assign seg_b = (~bitA & ~bitB & bitC & ~bitD) | (~bitA & ~bitB & ~bitC & bitD) | (bitA & ~bitB & ~bitC & ~bitD) | (~bitA & bitB & ~bitC & bitD);
    assign seg_c = (~bitA & bitB & ~bitC & ~bitD) | (bitA & ~bitB & ~bitC & ~bitD) | (~bitA & bitB & bitC & ~bitD) | (~bitA & ~bitB & ~bitC & bitD);
    assign seg_d = (~bitA & ~bitB & ~bitC & bitD) | (~bitA & bitB & bitC & bitD) | (bitA & ~bitB & ~bitC & bitD);
    assign seg_e = (~bitA & bitB & ~bitC & bitD) | (~bitA & bitB & bitC & ~bitD) | (bitA & ~bitB & ~bitC & bitD) | (bitA & bitB & ~bitC & ~bitD);
    assign seg_f = (bitA & ~bitB & bitC & ~bitD) | (~bitA & bitB & bitC & bitD) | (bitA & bitB & ~bitC & ~bitD) | (~bitA & ~bitB & bitC & bitD);
    assign seg_g = (bitA & bitB & bitC & bitD) | (~bitA & bitB & bitC & ~bitD) | (bitA & ~bitB & bitC & bitD) | (bitA & bitB & ~bitC & bitD);

endmodule