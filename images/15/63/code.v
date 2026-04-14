module mux4to1 (
    input wire A,
    input wire B,
    input wire C,
    input wire D,
    input wire [1:0] S,
    output reg Y
);

always @(*) begin
    case (S)
        2'b00: Y = A;
        2'b01: Y = B;
        2'b10: Y = C;
        2'b11: Y = D;
        default: Y = 1'b0; // Default case should not occur
    endcase
end

endmodule