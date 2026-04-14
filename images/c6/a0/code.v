module custom_or (
    input a,
    input b,
    input c,
    output x
);

    wire ab, abc;

    assign ab = a | b;
    assign abc = ab | c;
    assign x = abc;

endmodule