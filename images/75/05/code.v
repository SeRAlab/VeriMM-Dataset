module binary_subtractor_4bit(A, B, DIFF);
input [3:0] A, B;
output reg [4:0] DIFF;

always @(*) begin
    DIFF = A - B;
end

endmodule