module mux2to1 (
    input A,
    input B,
    input S,
    output Y
);

    // Select between A and B based on S
    assign Y = (S == 1'b0) ? A : B;

endmodule