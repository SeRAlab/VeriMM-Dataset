module matrix_inversion (
    input [3:0] a, // Element a of the matrix
    input [3:0] b, // Element b of the matrix
    input [3:0] c, // Element c of the matrix
    input [3:0] d, // Element d of the matrix
    output reg [3:0] out_11, // Inverted element [1,1]
    output reg [3:0] out_12, // Inverted element [1,2]
    output reg [3:0] out_21, // Inverted element [2,1]
    output reg [3:0] out_22  // Inverted element [2,2]
);
    wire signed [7:0] det; // Determinant variable
    assign det = (a * d) - (b * c); // Calculate determinant

    always @(*) begin
        if (det != 0) begin
            out_11 = d / det;
            out_12 = -b / det;
            out_21 = -c / det;
            out_22 = a / det;
        end else begin
            out_11 = 0;
            out_12 = 0;
            out_21 = 0;
            out_22 = 0;
        end
    end
endmodule