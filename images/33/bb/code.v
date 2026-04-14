module mux32bit (
    input [31:0] A,
    input [31:0] B,
    input [31:0] C,
    input [1:0] sel,
    output reg [31:0] Y
);

always @(*) begin
    case (sel)
        2'b00: Y = A;
        2'b01: Y = B;
        2'b10: Y = C;
        2'b11: Y = 32'b0; // Output zero
        default: Y = 32'b0; // Default case (should not happen)
    endcase
end

endmodule