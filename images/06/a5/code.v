module matrix_inverse (
    input [15:0] matrix, // 2x2 matrix represented as a 16-bit input (a, b, c, d)
    output reg [15:0] inverse // 2x2 matrix output
);

    wire [15:0] a = matrix[15:12];
    wire [15:0] b = matrix[11:8];
    wire [15:0] c = matrix[7:4];
    wire [15:0] d = matrix[3:0];

    wire signed [15:0] det = (a * d) - (b * c);

    always @(*) begin
        if (det == 0) begin
            inverse = 16'b0; // Indicating that the matrix is not invertible
        end else begin
            inverse = {d / det, -b / det, -c / det, a / det}; // Inverse calculation
        end
    end
endmodule