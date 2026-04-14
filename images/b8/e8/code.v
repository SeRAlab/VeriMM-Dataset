module top_module(
    input [31:0] a,
    input [31:0] b,
    input clk,
    output reg [31:0] c  // Changed to reg to allow assignment in always block
);reg [7:0] a_matrix [0:3][0:3];
reg [7:0] b_matrix [0:3][0:3];
reg [7:0] c_matrix [0:3][0:3];

integer i, j, k;

// Unpack input vectors into matrices
always @ (posedge clk) begin
    for (i = 0; i < 4; i = i + 1) begin
        for (j = 0; j < 4; j = j + 1) begin
            a_matrix[i][j] <= a[(i * 4 + j) * 8 +: 8];
            b_matrix[i][j] <= b[(i * 4 + j) * 8 +: 8];
        end
    end
end

// Compute matrix product
always @ (posedge clk) begin
    for (i = 0; i < 4; i = i + 1) begin
        for (j = 0; j < 4; j = j + 1) begin
            c_matrix[i][j] <= 0;
            for (k = 0; k < 4; k = k + 1) begin
                c_matrix[i][j] <= c_matrix[i][j] + a_matrix[i][k] * b_matrix[k][j];
            end
        end
    end
end

// Pack output matrix into output vector
always @ (posedge clk) begin
    for (i = 0; i < 4; i = i + 1) begin
        for (j = 0; j < 4; j = j + 1) begin
            c[(i * 4 + j) * 8 +: 8] <= c_matrix[i][j]; // Keep operation but modify the declaration of c
        end
    end
end

endmodule