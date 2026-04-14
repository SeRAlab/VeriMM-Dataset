module spec_module (
    input e, 
    input f, 
    input g, 
    input h,
    output reg z);assign z = (e & ~f & ~g & h) | (e & ~f & g & ~h) | (~e & ~f & g & h) | (e & f & g & h);

endmodule