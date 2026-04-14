module my_module(
    input a,
    input b,
    output reg z);assign z = (~a & ~b) | (a & ~b);

endmodule