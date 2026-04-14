module addsub (
    input [15:0] A,
    input [15:0] B,
    input C,
    output [15:0] Q
);

    assign Q = (C == 1'b1) ? A - B : A + B;

endmodule