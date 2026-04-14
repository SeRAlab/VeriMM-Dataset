module top_module (
    input e,
    input f,
    input g,
    input h,
    output k_sop,
    output k_pos);assign k_sop = (~e & ~f & ~g & h) | (~e & f & ~g & h) | (~e & f & g & h) | (~e & ~f & g & h);
assign k_pos = (e | f | g | h) & (e | ~f | g | ~h) & (e | f | ~g | h);
endmodule