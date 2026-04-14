module multiplier (
        input [1:0] a,
        input [1:0] b,
        output [3:0] p);

    assign p = a * b;

endmodule