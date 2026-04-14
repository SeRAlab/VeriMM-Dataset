module mux_2_1 (
    // Input ports
    input A,
    input B,
    input S,

    // Output port
    output Y
);

    assign Y = (S == 1) ? B : A;

endmodule