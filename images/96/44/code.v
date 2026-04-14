module subtractor (
        input [3:0] a,
        input [3:0] b,
        output [3:0] diff,
        output bout);

    assign {bout, diff} = a - b;

endmodule