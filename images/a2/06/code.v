module binary_subtractor(
    input [3:0] a,
    input [3:0] b,
    output [3:0] difference
);
    assign difference = a - b;
endmodule