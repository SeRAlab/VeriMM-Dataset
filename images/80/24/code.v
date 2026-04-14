module top_module(
    input [3:0] A,
    input [3:0] B,
    input [2:0] opcode,
    output reg [3:0] out,
    output reg zero
);always @(*) begin
        case(opcode)
            3'b000: out = A + B; // add
            3'b001: out = A - B; // subtract
            3'b010: out = A & B; // bitwise AND
            3'b011: out = A | B; // bitwise OR
            3'b100: out = A ^ B; // bitwise XOR
            3'b101: out = A << 1; // shift left
            3'b110: out = A >> 1; // shift right
            3'b111: out = ~A; // bitwise NOT
        endcase
        
        if(out == 4'b0000) begin
            zero = 1;
        end else begin
            zero = 0;
        end
    end
endmodule