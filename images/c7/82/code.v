module comparator_16bit (
    input [15:0] a,
    input [15:0] b,
    output eq
);

assign eq = (a == b);

endmodule