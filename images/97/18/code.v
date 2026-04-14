module logic_system (
    input m,
    input n,
    input o,
    input p,
    output s_sop,
    output s_pos);assign s_sop = (~m & ~n & ~o & ~p) | (m & ~n & ~o & p) | (~m & n & o & ~p) | (m & n & o & p);
assign s_pos = (m | n | o | ~p) & (m | ~n | ~o | ~p) & (~m | n | ~o | p);
endmodule