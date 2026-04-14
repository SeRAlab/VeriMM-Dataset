module and_4bit(A, B, Y);
input [3:0] A, B;
output reg [3:0] Y;

always @(*) begin
    Y = A & B;
end

endmodule