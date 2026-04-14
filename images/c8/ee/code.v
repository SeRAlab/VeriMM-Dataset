module mux_2to1 (
    A,
    B,
    Select,
    X
);

    input A;
    input B;
    input Select;
    output X;

    assign X = (Select == 0) ? A : B;

endmodule