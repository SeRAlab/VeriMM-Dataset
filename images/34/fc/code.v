module mux8to1 (
    input wire [7:0] D,
    input wire [2:0] S,
    output reg Y
);

always @(*) begin
    case (S)
        3'b000: Y = D[0];
        3'b001: Y = D[1];
        3'b010: Y = D[2];
        3'b011: Y = D[3];
        3'b100: Y = D[4];
        3'b101: Y = D[5];
        3'b110: Y = D[6];
        3'b111: Y = D[7];
        default: Y = 1'b0; // default case to avoid latches
    endcase
end

endmodule