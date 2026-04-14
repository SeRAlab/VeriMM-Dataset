module mux_2to1(
    input A,
    input B,
    input S,
    output Z
);

    assign Z = (S == 1'b1) ? A : B;

endmodule