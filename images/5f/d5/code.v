module my_module (
    input p,
    input q,
    input r,
    output m_sop,
    output m_pos);assign m_sop = (~p & q & ~r) | (p & ~q & ~r) | (p & q & r);
assign m_pos = (p | q | ~r) & (~p | ~q | ~r) & (~p | q | r);
endmodule