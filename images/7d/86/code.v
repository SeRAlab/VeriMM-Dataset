module conditional_logic (
    input x,
    input y,
    input z,
    output v_sop,
    output v_pos);assign v_sop = (~x & ~y & ~z) | (x & ~y & ~z) | (x & y & ~z);
assign v_pos = (x | y | z) & (~x | ~y | z) & (~x | y | ~z);
endmodule