module top_module(
    A,
    B,
    C,
    D,
    SEL0,
    SEL1,
    Y
);// Module ports
    input A;
    input B;
    input C;
    input D;
    input SEL0;
    input SEL1;
    output Y;

    // Local signals
    wire Y_temp1;
    wire Y_temp2;

    // 4:1 MUX
    assign Y_temp1 = SEL1 & SEL0 & A;
    assign Y_temp2 = SEL1 & ~SEL0 & B;
    assign Y_temp3 = ~SEL1 & SEL0 & C;
    assign Y_temp4 = ~SEL1 & ~SEL0 & D;
    assign Y = Y_temp1 | Y_temp2 | Y_temp3 | Y_temp4;

endmodule