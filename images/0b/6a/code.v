module matrix_inverse(
    input [7:0] a, // Element a11
    input [7:0] b, // Element a12
    input [7:0] c, // Element a21
    input [7:0] d, // Element a22
    output reg [7:0] inv_a, // Element a11'
    output reg [7:0] inv_b, // Element a12'
    output reg [7:0] inv_c, // Element a21'
    output reg [7:0] inv_d  // Element a22'
);
    reg [15:0] det; // Determinant
    always @(*) begin
        det = a * d - b * c; // Compute determinant
        if (det == 0) begin
            inv_a = 8'd0;
            inv_b = 8'd0;
            inv_c = 8'd0;
            inv_d = 8'd0;
        end else begin
            inv_a = d / det; // Inverse a11
            inv_b = -b / det; // Inverse a12
            inv_c = -c / det; // Inverse a21
            inv_d = a / det; // Inverse a22
        end
    end
endmodule