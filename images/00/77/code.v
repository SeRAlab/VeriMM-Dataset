module matrix_inversion (
    input [15:0] matrix_input, // 4x4 bits representing 2x2 matrix
    output reg [15:0] matrix_output // 4x4 bits representing inverted matrix or error
);

    wire [15:0] a, b, c, d;
    assign a = matrix_input[15:12];
    assign b = matrix_input[11:8];
    assign c = matrix_input[7:4];
    assign d = matrix_input[3:0];

    wire signed [15:0] det = (a * d) - (b * c);
    
    always @(*) begin
        if (det == 0) begin
            matrix_output = 16'hFFFF; // error code for non-invertible matrix
        end else begin
            matrix_output[15:12] = d / det; // d/(ad-bc)
            matrix_output[11:8]  = -b / det; // -b/(ad-bc)
            matrix_output[7:4]   = -c / det; // -c/(ad-bc)
            matrix_output[3:0]   = a / det; // a/(ad-bc)
        end
    end

endmodule