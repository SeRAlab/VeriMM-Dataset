module dffns(
    output reg Q,
    input D,
    input C,
    input S
);

    always @(negedge C or negedge S)
        if (!S)
            Q <= 1'b1;
        else
            Q <= D;

endmodule