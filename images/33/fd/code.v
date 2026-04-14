module matrix_inverse (
    input [7:0] a, b, c, d, // Elements of the matrix
    output reg [7:0] a_inv, b_inv, c_inv, d_inv // Inverse elements
);
    wire signed [15:0] determinant;
    wire signed [15:0] inv_det;

    // Calculate the determinant of the matrix
    assign determinant = (a * d) - (b * c);
    assign inv_det = (determinant == 0) ? 0 : (1 << 8) / determinant; // 1.0 in fixed point

    always @(*) begin
        if (determinant == 0) begin
            a_inv = 8'b11111111;
            b_inv = 8'b11111111;
            c_inv = 8'b11111111;
            d_inv = 8'b11111111;
        end else begin
            a_inv = (d * inv_det) >> 8; // a' = d / det
            b_inv = (-b * inv_det) >> 8; // b' = -b / det
            c_inv = (-c * inv_det) >> 8; // c' = -c / det
            d_inv = (a * inv_det) >> 8; // d' = a / det
        end
    end
endmodule