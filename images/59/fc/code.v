module top_module(
    input A,
    input B,
    input C,
    input D,
    input [1:0] SEL,
    output reg Y  // Changed to reg type
);always @(*) begin
        case (SEL)
            2'b00: Y = A;
            2'b01: Y = B;
            2'b10: Y = C;
            2'b11: Y = D;
            default: Y = 1'b0; // Adding default case for safety
        endcase
    end

endmodule