module top_module (
    input a,
    input b,
    input c,
    input d,
    output q_sop,
    output q_pos);assign q_sop = (~a & ~b & ~c & d) | (~a & b & ~c & ~d) | (~a & ~b & c & ~d) | (a & ~b & ~c & ~d);
assign q_pos = (a | b | c | ~d) & (a | ~b | ~c | d) & (a | b | ~c | ~d) & (~a | ~b | ~c | d);
endmodule