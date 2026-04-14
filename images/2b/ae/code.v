module cholesky_decomp (
    input clk,
    input rst,
    input en,
    input [15:0] matrix_in, // 4 elements in 4-bit each
    output reg [15:0] lower_out // 4 elements in 4-bit each
);
    reg [7:0] a, b, c, d; // Elements of the matrix
    reg [7:0] l1, l2, l3; // Elements of the lower triangular matrix

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            lower_out <= 16'b0;
        end else if (en) begin
            a <= matrix_in[15:12];
            b <= matrix_in[11:8];
            c <= matrix_in[7:4];
            d <= matrix_in[3:0];

            l1 <= a[3:0];  // l11 = sqrt(a)
            l2 <= b / l1;  // l21 = b / l11
            l3 <= c - l2 * l2; // l22 = sqrt(c - l21^2

            lower_out <= {l1, l2, l3};
        end
    end
endmodule