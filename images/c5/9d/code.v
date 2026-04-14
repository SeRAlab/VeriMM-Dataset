module bit_manipulation (
    input  wire [3:0] I,
    output wire [1:0] O
);

    assign O[0] = I[3] ? 0 : 1;
    assign O[1] = I[3] ? 1 : 0;

endmodule