module top_module (
    input m,
    input n,
    input o,
    output j_sop,
    output j_pos);assign j_sop = (~m & n & ~o) | (m & ~n & ~o) | (m & ~n & o);
assign j_pos = (~m | ~n | ~o) & (m | ~n | ~o) & (m | n | ~o);
endmodule