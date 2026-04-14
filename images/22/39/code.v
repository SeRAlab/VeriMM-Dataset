module ALU_8bit(
    input [7:0] A,
    input [7:0] B,
    input [2:0] control,
    output reg [7:0] R,
    output reg C_out
);
    
    always @(*) begin
        case(control)
            3'b000: R = A & B;          // AND
            3'b001: R = A | B;          // OR
            3'b010: begin                // ADD
                {C_out, R} = A + B;
            end
            3'b011: begin                // SUBTRACT
                {C_out, R} = A - B;
            end
            3'b100: R = A ^ B;          // XOR
            3'b101: R = ~A;             // NOT
            3'b110: R = A << 1;         // SHIFT LEFT
            3'b111: R = A >> 1;         // SHIFT RIGHT
            default: R = 8'b00000000;   // Default case
        endcase
    end
endmodule