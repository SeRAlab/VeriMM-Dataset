module digital_system (
    input x,
    input y,
    input z,
    input w,
    output n_sop,
    output n_pos);assign n_sop = (~x & ~y & ~z & w) | (~x & y & ~z & ~w) | (x & ~y & ~z & ~w) | (x & y & z & ~w);
assign n_pos = (x | y | z | w) & (x | ~y | z | w) & (~x | y | z | w) & (~x | ~y | ~z | ~w);
endmodule