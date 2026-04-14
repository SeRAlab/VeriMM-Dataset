module matrix_inverse(
    input [7:0] a,   // Element a of the matrix
    input [7:0] b,   // Element b of the matrix
    input [7:0] c,   // Element c of the matrix
    input [7:0] d,   // Element d of the matrix
    output reg [15:0] inv_a, // Inverse of the matrix element a (output)
    output reg [15:0] inv_b, // Inverse of the matrix element b (output)
    output reg [15:0] inv_c, // Inverse of the matrix element c (output)
    output reg [15:0] inv_d  // Inverse of the matrix element d (output)
);

wire signed [15:0] det;
assign det = (a * d - b * c); // Calculate determinant

always @(*) begin
    if (det != 0) begin
        inv_a = d / det;
        inv_b = -b / det;
        inv_c = -c / det;
        inv_d = a / det;
    end else begin
        inv_a = 16'hFFFF; // Error code for non-invertible matrix
        inv_b = 16'hFFFF;
        inv_c = 16'hFFFF;
        inv_d = 16'hFFFF;
    end
end

endmodule