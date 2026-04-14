module top_module(
    a,
    b,
    c,
    en,
    out
);input a;
    input b;
    input c;
    input en;
    output out;

    reg out_reg;

    always @(posedge en)
        if (en)
            out_reg <= a & b & c;
        else
            out_reg <= 1'b0;

    assign out = out_reg;

endmodule