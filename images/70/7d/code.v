module top_module(a, b, alu_ctrl, result);input [15:0] a, b;
    input [2:0] alu_ctrl;
    output reg [15:0] result;

    always @(*) begin
        case (alu_ctrl)
            3'b000: result = a & b;          // AND
            3'b001: result = a | b;          // OR
            3'b010: result = a + b;          // ADD
            3'b011: result = a - b;          // SUB
            3'b100: result = a << 1;         // SHL
            3'b101: result = a >> 1;         // SHR
            3'b110: result = a ^ b;          // XOR
            3'b111: result = ~(a & b);       // NAND
            default: result = 16'h0000;      // Default case
        endcase
    end
endmodule