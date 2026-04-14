module logic_circuit (
    input a,
    input b,
    input c,
    output p_sop,
    output p_pos);assign p_sop = (~a & ~b & ~c) | (~a & ~b & c) | (a & ~b & c);
assign p_pos = (a | b | c) & (a | b | ~c) & (~a | ~b | ~c);
endmodule