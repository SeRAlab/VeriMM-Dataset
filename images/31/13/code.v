module matrix_inversion (
    input [15:0] a, b, c, d, // 4 inputs for the matrix elements
    output reg [15:0] inv_a, inv_b, inv_c, inv_d // 4 outputs for the inverted matrix elements
);
    wire [31:0] det; // 32-bit wire for determinant
    assign det = a * d - b * c; // Calculate determinant

    always @(*) begin
        if (det != 0) begin
            inv_a = d / det; // Calculate inverted matrix elements
            inv_b = -b / det;
            inv_c = -c / det;
            inv_d = a / det;
        end else begin
            inv_a = 16'hxxxx; // Undefined behavior for zero determinant
            inv_b = 16'hxxxx;
            inv_c = 16'hxxxx;
            inv_d = 16'hxxxx;
        end
    end
endmodule