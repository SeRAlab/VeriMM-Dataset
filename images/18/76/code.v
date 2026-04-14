module mux4to1 (
    input [15:0] A,
    input [15:0] B,
    input [15:0] C,
    input [15:0] D,
    input [1:0] S,
    output reg [15:0] Y
);
    always @(*) begin
        case (S)
            2'b00: Y = A;
            2'b01: Y = B;
            2'b10: Y = C;
            2'b11: Y = D;
            default: Y = 16'b0; // default case
        endcase
    end
endmodule