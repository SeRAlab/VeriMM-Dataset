module top_module(
    input A1,
    input A2,
    input A3,
    input B1,
    input B2,
    output X
);wire and_output;
    wire or_output;
    wire xor_output;

    assign and_output = A1 & A2 & A3;
    assign or_output = B1 | B2;
    assign xor_output = and_output ^ or_output;
    assign X = ~xor_output;

endmodule