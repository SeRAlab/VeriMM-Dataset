module matrix_inversion (
    input [7:0] a, // First element of the matrix
    input [7:0] b, // Second element of the first row
    input [7:0] c, // First element of the second row
    input [7:0] d, // Second element of the second row
    output reg [15:0] a_inv, // First element of the inverted matrix
    output reg [15:0] b_inv, // Second element of the inverted matrix
    output reg [15:0] c_inv, // Third element of the inverted matrix
    output reg [15:0] d_inv // Fourth element of the inverted matrix
);
    wire [15:0] det;
    
    assign det = a * d - b * c; // Determinant calculation

    always @(*) begin
        if (det == 0) begin
            a_inv = 16'b0; // Indicating error with zero matrix
            b_inv = 16'b0;
            c_inv = 16'b0;
            d_inv = 16'b0;
        end else begin
            a_inv = d * 16'h1 / det; // Inverse calculation
            b_inv = -b * 16'h1 / det;
            c_inv = -c * 16'h1 / det;
            d_inv = a * 16'h1 / det;
        end
    end
endmodule