module matrix_inverse (
    input [7:0] a11, a12,   // First row of the matrix
    input [7:0] a21, a22,   // Second row of the matrix
    output reg [7:0] inv11, inv12, // Inverse matrix output
    output reg [7:0] inv21, inv22, 
    output reg valid         // Output valid signal
);
    
    wire signed [15:0] determinant;
    
    // Calculate determinant
    assign determinant = a11 * a22 - a12 * a21;
    
    always @(*) begin
        if (determinant != 0) begin
            // Compute inverse: inv = 1/det * adjugate
            inv11 = a22 / determinant;
            inv12 = -a12 / determinant;
            inv21 = -a21 / determinant;
            inv22 = a11 / determinant;
            valid = 1; // Valid inverse
        end else begin
            // If determinant is zero, output a zero matrix
            inv11 = 8'b0;
            inv12 = 8'b0;
            inv21 = 8'b0;
            inv22 = 8'b0;
            valid = 0; // Invalid inverse
        end
    end
endmodule