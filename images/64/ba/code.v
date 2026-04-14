module logic_unit (
    input a,
    input b,
    input c,
    input d,
    output u_sop,
    output u_pos);assign u_sop = (~a & b & ~c & ~d) | (a & b & c & d) | (~a & b & c & ~d) | (a & ~b & c & ~d);
assign u_pos = (a | ~b | c | d) & (a | b | ~c | d) & (~a | b | c | ~d);
endmodule