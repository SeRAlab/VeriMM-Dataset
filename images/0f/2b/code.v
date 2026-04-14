module matrix_inverse (
    input [15:0] matrix_in,  // 4x4 bits for 2x2 matrix
    output reg [15:0] matrix_out // 4x4 bits for inverted 2x2 matrix
);
    wire [7:0] a, b, c, d;
    wire [15:0] det;

    assign a = matrix_in[15:12];
    assign b = matrix_in[11:8];
    assign c = matrix_in[7:4];
    assign d = matrix_in[3:0];

    assign det = a * d - b * c; // Determinant calculation

    always @(*) begin
        if (det != 0) begin
            matrix_out = {d / det, -b / det, -c / det, a / det};
        end else begin
            matrix_out = 16'b0; // Return zero matrix if singular
        end
    end
endmodule