module dot_product (
    input [4:0] vector_a,
    input [4:0] vector_b,
    output reg [9:0] result
);
    always @(*) begin
        result = vector_a[0]*vector_b[0] +
                 vector_a[1]*vector_b[1] +
                 vector_a[2]*vector_b[2] +
                 vector_a[3]*vector_b[3] +
                 vector_a[4]*vector_b[4];
    end
endmodule