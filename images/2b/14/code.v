module matrix_inverse (
    input [7:0] a, b, c, d,
    output reg [7:0] inv_a, inv_b, inv_c, inv_d,
    output reg valid
);
    wire signed [15:0] det;
    assign det = a * d - b * c;

    always @(*) begin
        if (det == 0) begin
            valid = 0; // Matrix is not invertible
            inv_a = 8'b0;
            inv_b = 8'b0;
            inv_c = 8'b0;
            inv_d = 8'b0;
        end else begin
            valid = 1; // Matrix is invertible
            inv_a = d / det;
            inv_b = -b / det;
            inv_c = -c / det;
            inv_d = a / det;
        end
    end
endmodule