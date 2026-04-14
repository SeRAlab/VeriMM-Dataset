module top_module (
    input a,
    input b,
    input c,
    output l_sop,
    output l_pos);assign l_sop = (~a & ~b & c) | (~a & b & ~c) | (a & ~b & ~c);
assign l_pos = (a | b | ~c) & (~a | ~b | c) & (~a | b | ~c);
endmodule