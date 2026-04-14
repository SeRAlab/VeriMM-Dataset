module binary_converter (
    input wire A,
    output wire X
);

    assign X = ~A;

endmodule