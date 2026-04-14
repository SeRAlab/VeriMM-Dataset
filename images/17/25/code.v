module chebyshev_filter (
    input [4:0] x,
    output reg [4:0] y
);
    always @(*) begin
        // Simple implementation of a 3rd order Chebyshev filter
        y[0] = x[0]; // Directly pass the input for simplicity
        y[1] = (x[0] + x[1]) >> 1; // Average of first two inputs
        y[2] = (x[0] + x[1] + x[2]) / 3; // Average of first three inputs
        y[3] = (x[1] + x[2] + x[3]) / 3; // Average of second, third and fourth inputs
        y[4] = (x[2] + x[3] + x[4]) / 3; // Average of third, fourth and fifth inputs
    end
endmodule