module fir_filter (
    input [3:0] x, // 4-bit input
    output [7:0] y // 8-bit output to accommodate sum
);
    assign y = (x[0] * 1) + (x[1] * 2) + (x[2] * 3) + (x[3] * 4);
endmodule