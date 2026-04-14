module two_input_inv (
    input a,
    input b,
    output y
);

    wire not_a;
    wire not_b;
    wire a_and_b;

    assign not_a = ~a;
    assign not_b = ~b;
    assign a_and_b = a & b;

    assign y = not_a & not_b;

endmodule