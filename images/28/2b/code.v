module dwt (
    input [3:0] x,
    output [3:0] y
);
    assign y[3] = (x[3] + x[2]) >> 1; // Approximation coefficient (average)
    assign y[2] = (x[3] - x[2]) >> 1; // Detail coefficient (difference)
    assign y[1] = (x[1] + x[0]) >> 1; // Approximation coefficient (average)
    assign y[0] = (x[1] - x[0]) >> 1; // Detail coefficient (difference)
endmodule