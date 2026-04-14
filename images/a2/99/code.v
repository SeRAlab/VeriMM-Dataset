module binary_adder_4bit(A, B, SUM);
input [3:0] A, B;
output reg [4:0] SUM;

always @(*) begin
    SUM = A + B;
end

endmodule