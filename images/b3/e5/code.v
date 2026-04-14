module combinational_logic (
    input d,
    input e,
    input f,
    input g,
    output q_sop,
    output q_pos);assign q_sop = (~d & e & f & ~g) | (d & e & f & ~g) | (~d & ~e & f & g) | (d & ~e & f & g);
assign q_pos = (d | ~e | f | g) & (d | e | ~f | ~g) & (~d | e | f | ~g);
endmodule