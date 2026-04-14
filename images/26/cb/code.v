module matrix_inverse (
    input [15:0] matrix,  // 4x4 bits for a 2x2 matrix (a, b, c, d)
    output reg [15:0] inverse,  // 4x4 bits for the inverse matrix
    output reg valid  // Indicates if the inverse is valid
);
    wire signed [7:0] a, b, c, d;
    assign {a, b, c, d} = matrix;

    wire signed [15:0] det;
    assign det = a * d - b * c;

    always @(*) begin
        if(det == 0) begin
            inverse = 16'hFFFF; // Indicating undefined
            valid = 0;
        end else begin
            inverse = {d / det, -b / det, -c / det, a / det};
            valid = 1;
        end
    end
endmodule