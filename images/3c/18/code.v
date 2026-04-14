module divider_2bit (
    input [1:0] A,
    input [1:0] B,
    output reg [1:0] Q
);
    always @(*) begin
        case (B)
            2'b00: Q = 2'b00; // Division by zero case
            2'b01: Q = A;     // A divided by 1
            2'b10: Q = A / 2; // A divided by 2
            2'b11: Q = A / 3; // A divided by 3
            default: Q = 2'b00; // Should not occur
        endcase
    end
endmodule