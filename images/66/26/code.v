module top_module(
    input [7:0] A,
    input [7:0] B,
    input [2:0] op,
    output reg [7:0] C
);always @(*) begin
    case (op)
        3'b000: C = A + B;
        3'b001: C = A - B;
        3'b010: C = A * B;
        3'b011: if (B == 8'b0) C = 8'b11111111; else C = A / B;
        default: C = 8'b00000000;
    endcase
end

endmodule