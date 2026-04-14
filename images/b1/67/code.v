module binary_decoder(
    input [1:0] a,
    output [3:0] y
);
    assign y = 1 << a;
endmodule