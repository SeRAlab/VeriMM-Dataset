module MatrixInverse (
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output reg [15:0] a_inv,
    output reg [15:0] b_inv,
    output reg [15:0] c_inv,
    output reg [15:0] d_inv
);
    wire [15:0] det;
    assign det = a * d - b * c; // Determinant

    always @(*) begin
        if (det != 0) begin
            a_inv = d / det;
            b_inv = -b / det;
            c_inv = -c / det;
            d_inv = a / det;
        end else begin
            a_inv = 16'hFFFF; // Indicate non-invertible matrix
            b_inv = 16'hFFFF;
            c_inv = 16'hFFFF;
            d_inv = 16'hFFFF;
        end
    end
endmodule