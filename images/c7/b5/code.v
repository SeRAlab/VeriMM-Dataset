module greater_than (
    input [7:0] A,
    input [7:0] B,
    input [7:0] C,
    output Y
);

    assign Y = (A >= B) && (C < B);

endmodule