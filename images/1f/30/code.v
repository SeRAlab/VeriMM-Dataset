module dot_product (
    input [4:0] A,
    input [4:0] B,
    input enable,
    output reg [9:0] R
);
    always @(*) begin
        if (enable) begin
            R = A[0]*B[0] + A[1]*B[1] + A[2]*B[2] + A[3]*B[3] + A[4]*B[4];
        end else begin
            R = 10'b0;
        end
    end
endmodule