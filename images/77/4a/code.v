module boolean_logic (
    input u,
    input v,
    input w,
    output r_sop,
    output r_pos);assign r_sop = (~u & ~v & w) | (~u & v & ~w) | (u & v & w);
assign r_pos = (u | v | ~w) & (u | ~v | w) & (~u | ~v | w);
endmodule