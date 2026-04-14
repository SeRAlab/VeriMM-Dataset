module binary_to_gray (
    input wire [1:0] a,
    output wire [1:0] y
);
    assign y[1] = a[1];
    assign y[0] = a[1] ^ a[0];
endmodule