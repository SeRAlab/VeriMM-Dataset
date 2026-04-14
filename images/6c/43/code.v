module top_module (
    input p,
    input q,
    input r,
    input s,
    output i_sop,
    output i_pos);assign i_sop = p & q;
assign i_pos = (p | ~q) & (p | ~r) & (p | ~s);
endmodule