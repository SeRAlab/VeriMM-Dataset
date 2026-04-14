module digital_logic (
    input e,
    input f,
    input g,
    input h,
    output w_sop,
    output w_pos);assign w_sop = (~e & ~f & ~g & h) | (~e & f & ~g & h) | (e & ~f & ~g & ~h) | (e & f & g & ~h);
assign w_pos = (e | f | g | ~h) & (e | ~f | g | ~h) & (~e | f | g | h);
endmodule