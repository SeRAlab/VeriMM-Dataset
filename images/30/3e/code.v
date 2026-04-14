module multiplier_2bit (
    input [1:0] A,
    input [1:0] B,
    output reg [3:0] P
);
    always @(*) begin
        P = A * B; // Multiply A and B
    end
endmodule