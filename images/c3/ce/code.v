module and_nor_buffer (
    Y,
    A1,
    A2,
    A3,
    B1,
    C1
);

    output Y;
    input A1;
    input A2;
    input A3;
    input B1;
    input C1;

    wire and_out;
    wire nor_out;

    and and_gate(
        .out(and_out),
        .in1(A1),
        .in2(A2),
        .in3(A3)
    );

    nor nor_gate(
        .out(nor_out),
        .in1(and_out),
        .in2(B1),
        .in3(C1)
    );

    buf buf_gate(
        .out(Y),
        .in(nor_out)
    );

endmodule