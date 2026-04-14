module multiplier_2x2 (
    input [1:0] A,
    input [1:0] B,
    output reg [3:0] P,
    output reg [3:0] Q
);

    always @(*) begin
        P = A * B[0];
        Q = A * B[1];
    end

endmodule