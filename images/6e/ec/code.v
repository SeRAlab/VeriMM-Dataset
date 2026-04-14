module top_module(
    input [3:0] A,
    input [3:0] B,
    input [2:0] opcode,
    input clk,               // Added clk input
    output reg [3:0] out,
    output reg zero
);reg [3:0] result;

// Removed A_reg and B_reg as they are not needed
// Directly use A and B in the computation

always @(*) begin
    case (opcode)
        3'b000: result = A + B;          // Use non-blocking assignment
        3'b001: result = A - B;          // Use non-blocking assignment
        3'b010: result = A & B;          // Use non-blocking assignment
        3'b011: result = A | B;          // Use non-blocking assignment
        3'b100: result = A ^ B;          // Use non-blocking assignment
        3'b101: result = A << 1;         // Use non-blocking assignment
        3'b110: result = A >> 1;         // Use non-blocking assignment
        3'b111: result = ~A;             // Use non-blocking assignment
        default: result = 4'b0000;       // Default case
    endcase
end

always @(posedge clk) begin
    out <= result;                     // Non-blocking assignment
    zero <= (result == 0);             // Non-blocking assignment for zero
end

endmodule