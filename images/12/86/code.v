module multiplier_64bit (
    input [63:0] A,
    input [63:0] B,
    output reg [127:0] P
);
    always @(*) begin
        P = A * B; // Multiplying the two 64-bit inputs
    end
endmodule