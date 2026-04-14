module matrix_inverse(
    input [3:0] A, // Element A (row 1, column 1)
    input [3:0] B, // Element B (row 1, column 2)
    input [3:0] C, // Element C (row 2, column 1)
    input [3:0] D, // Element D (row 2, column 2)
    output reg [3:0] A_inv, // Inverse Element A
    output reg [3:0] B_inv, // Inverse Element B
    output reg [3:0] C_inv, // Inverse Element C
    output reg [3:0] D_inv // Inverse Element D
);
    wire [3:0] det; // Determinant
    assign det = A * D - B * C; // Calculate determinant

    always @(*) begin
        if (det != 0) begin
            A_inv = D / det; // A_inv = D/det
            B_inv = -B / det; // B_inv = -B/det
            C_inv = -C / det; // C_inv = -C/det
            D_inv = A / det; // D_inv = A/det
        end else begin
            A_inv = 4'b0000; // Not invertible
            B_inv = 4'b0000;
            C_inv = 4'b0000;
            D_inv = 4'b0000;
        end
    end
endmodule