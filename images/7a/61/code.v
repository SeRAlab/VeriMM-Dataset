module binary_comparator_3bit(A, B, EQUAL);
input [2:0] A, B;
output reg EQUAL;

always @(*) begin
    EQUAL = (A == B);
end

endmodule