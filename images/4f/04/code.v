module top_module(
    Y,
    A,
    B,
    C,
    D,
    select
);// Module ports
    output Y;
    input A, B, C, D;
    input [1:0] select;

    // Local signals
    wire sel0, sel1;

    //  Name  Output      Other arguments
    assign sel0 = select[0];
    assign sel1 = select[1];

    assign Y = (sel1 & sel0 & D) |
               (sel1 & ~sel0 & C) |
               (~sel1 & sel0 & B) |
               (~sel1 & ~sel0 & A);

endmodule