module mux_2_to_1 (
    input A,
    input B,
    input S,
    output reg Y
);

    assign Y = (S == 0) ? A : B;

endmodule