module matrix_inversion (
    input [15:0] matrix_in, // 2x2 matrix represented as {a, b, c, d}
    output reg [15:0] matrix_out // Inverted matrix output
);
    wire signed [15:0] a = matrix_in[15:12];
    wire signed [15:0] b = matrix_in[11:8];
    wire signed [15:0] c = matrix_in[7:4];
    wire signed [15:0] d = matrix_in[3:0];
    
    wire signed [15:0] det = (a * d) - (b * c);
    
    always @(*) begin
        if (det != 0) begin
            matrix_out = {d / det, -b / det, -c / det, a / det};
        end else begin
            matrix_out = 16'h0000; // Indicating non-invertible matrix
        end
    end
endmodule