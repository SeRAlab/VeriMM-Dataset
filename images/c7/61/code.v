module and_en(
    input A,
    input B,
    input C1,
    output Y
);

    wire and_out;

    and and_gate(
        .A(A),
        .B(B),
        .Z(and_out)
    );

    assign Y = and_out & C1;

endmodule