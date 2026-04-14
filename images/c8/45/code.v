module adder_16bit (
    input [15:0] A,
    input [15:0] B,
    input CIN,
    output reg [15:0] S
);

    always @(A, B, CIN) begin
        S = A + B + CIN;
    end

endmodule