module top_module(
    input [63:0] A,
    input [63:0] B,
    output [63:0] product
);reg [15:0] a [0:3][0:3];
reg [15:0] b [0:3][0:3];
reg [15:0] c [0:3][0:3];

integer i, j, k;

// Splitting the input vectors into 4x4 matrices
genvar row, col;
generate
    for (row = 0; row < 4; row = row + 1) begin
        for (col = 0; col < 4; col = col + 1) begin
            assign a[row][col] = A[(row * 4 + col) * 16 +: 16];
            assign b[row][col] = B[(row * 4 + col) * 16 +: 16];
        end
    end
endgenerate

// Combinational circuit for matrix multiplication
generate
    for (row = 0; row < 4; row = row + 1) begin
        for (col = 0; col < 4; col = col + 1) begin
            always @* begin
                c[row][col] = 0;
                for (k = 0; k < 4; k = k + 1) begin
                    c[row][col] = c[row][col] + a[row][k] * b[k][col];
                end
            end
        end
    end
endgenerate

// Combining the output matrix into a single vector
generate
    for (row = 0; row < 4; row = row + 1) begin
        for (col = 0; col < 4; col = col + 1) begin
            assign product[(row * 4 + col) * 16 +: 16] = c[row][col];
        end
    end
endgenerate

endmodule