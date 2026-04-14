module top_module(
    A,
    B,
    Select,
    X
);input A;
    input B;
    input Select;
    output X;

    assign X = (Select == 0) ? A : B;

endmodule