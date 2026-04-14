module top_module(
    input [3:0] A,
    input [3:0] B,
    input [3:0] C,
    input [3:0] D,
    input [1:0] S,
    output reg [3:0] Y
);always @(*) begin
        case (S)
            2'b00: Y = A; // Select A
            2'b01: Y = B; // Select B
            2'b10: Y = C; // Select C
            2'b11: Y = D; // Select D
            default: Y = 4'b0000; // Default case
        endcase
    end

endmodule