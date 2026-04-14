module mux_2to1 (
    input A,
    input B,
    input SEL,
    output OUT
);

    assign OUT = (SEL == 1'b0) ? A : B;

endmodule