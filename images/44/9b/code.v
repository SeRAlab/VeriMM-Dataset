module binary_comparator
    (
        input [3:0] a,
        input [3:0] b,
        output gt,
        output eq,
        output lt
    );

    assign gt = (a > b);
    assign eq = (a == b);
    assign lt = (a < b);

endmodule