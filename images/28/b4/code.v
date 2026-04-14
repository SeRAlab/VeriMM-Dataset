module mux_4to1 (
    input [7:0] A,
    input [7:0] B,
    input [7:0] C,
    input [7:0] D,
    input [1:0] S,
    output reg [7:0] Y
);
    always @(*) begin
        case (S)
            2'b00: Y = A;
            2'b01: Y = B;
            2'b10: Y = C;
            2'b11: Y = D;
            default: Y = 8'b00000000; // Default case
        endcase
    end
endmodule