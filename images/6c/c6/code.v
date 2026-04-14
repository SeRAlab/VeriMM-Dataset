module comparator_4bit (
    input [3:0] a,
    input [3:0] b,
    output lt,
    output eq,
    output gt
);

    assign lt = (a < b) ? 1'b1 : 1'b0;
    assign eq = (a == b) ? 1'b1 : 1'b0;
    assign gt = (a > b) ? 1'b1 : 1'b0;
endmodule