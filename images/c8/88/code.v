module custom_logic(
    input a,
    input b,
    output o
);

assign o = (a & ~b) | (~a & b);

endmodule