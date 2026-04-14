module matrix_inverse (
    input [31:0] matrix_in, // 2x2 matrix flattened (a, b, c, d)
    output reg [31:0] matrix_out // Inverse of matrix (a_inv, b_inv, c_inv, d_inv)
);
    wire [31:0] determinant;
    wire [31:0] a, b, c, d;

    assign a = matrix_in[31:24];
    assign b = matrix_in[23:16];
    assign c = matrix_in[15:8];
    assign d = matrix_in[7:0];

    assign determinant = (a * d - b * c);

    always @(*) begin
        if (determinant != 0) begin
            matrix_out = {d/determinant, -b/determinant, -c/determinant, a/determinant};
        end else begin
            matrix_out = 32'hFFFFFFFF; // Error value
        end
    end
endmodule