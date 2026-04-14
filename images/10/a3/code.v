module matrix_inversion (
    input [15:0] matrix_in, // 2x2 matrix input as a 16-bit value
    output reg [15:0] matrix_out // 2x2 matrix output as a 16-bit value
);
    wire [31:0] determinant;
    wire [15:0] adjoint;

    // Matrix elements
    wire [3:0] a = matrix_in[15:12];
    wire [3:0] b = matrix_in[11:8];
    wire [3:0] c = matrix_in[7:4];
    wire [3:0] d = matrix_in[3:0];

    // Determinant calculation: det = ad - bc
    assign determinant = (a * d) - (b * c);

    // Adjoint matrix calculation: adjoint = [[d, -b], [-c, a]]
    assign adjoint = {d, -b, -c, a};

    always @(*) begin
        if (determinant == 0) begin
            matrix_out = 16'b0; // Output zero matrix for singular case
        end else begin
            matrix_out = adjoint / determinant; // Output inverted matrix
        end
    end
endmodule