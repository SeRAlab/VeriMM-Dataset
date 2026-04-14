module custom_module(
    input A1,
    input A2,
    input B1,
    input VPWR,
    input VGND,
    input VPB,
    input VNB,
    output Y
);

    wire and_out;
    wire nor_out;

    and and_gate(
        .a(A1),
        .b(A2),
        .y(and_out)
    );

    nor nor_gate(
        .a(B1),
        .b(and_out),
        .y(nor_out)
    );

    assign Y = ~nor_out;

endmodule