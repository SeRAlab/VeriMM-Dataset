module matrix_inverse (
    input [31:0] a, b,  // Matrix elements
    input [31:0] c, d,  // Matrix elements
    output reg [31:0] inv_a, inv_b,  // Inverted matrix elements
    output reg [31:0] inv_c, inv_d,
    output reg valid      // Indicates if inversion was successful
);
    wire signed [31:0] det;
    
    assign det = (a * d) - (b * c); // Determinant

    always @(*) begin
        if (det == 0) begin
            // Matrix is not invertible
            inv_a = 32'b0;
            inv_b = 32'b0;
            inv_c = 32'b0;
            inv_d = 32'b0;
            valid = 1'b0;
        end else begin
            // Compute inverse
            inv_a = d / det;
            inv_b = -b / det;
            inv_c = -c / det;
            inv_d = a / det;
            valid = 1'b1;
        end
    end
endmodule