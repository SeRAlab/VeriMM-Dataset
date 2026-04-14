module comparator (
        input [3:0] a,
        input [3:0] b,
        output eq);

    assign eq = (a == b);

endmodule