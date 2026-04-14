module matrix_inverse (
    input [7:0] a00, a01, a10, a11, // 2x2 matrix entries
    output reg [7:0] b00, b01, b10, b11 // Inverse matrix entries
);
    wire [15:0] det; // Determinant
    assign det = a00 * a11 - a01 * a10; // Calculate determinant

    always @(*) begin
        if (det != 0) begin
            b00 = a11 / det; // Inverse calculation
            b01 = -a01 / det;
            b10 = -a10 / det;
            b11 = a00 / det;
        end else begin
            b00 = 0;
            b01 = 0;
            b10 = 0;
            b11 = 0; // Output zero matrix if determinant is zero
        end
    end
endmodule