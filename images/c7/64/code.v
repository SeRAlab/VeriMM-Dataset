module three_to_one (
    input [1:0] A,
    input [1:0] B,
    input [1:0] C,
    output [2:0] Y
);

    assign Y = {A, B, C};

endmodule