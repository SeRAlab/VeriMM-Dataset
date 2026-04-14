module top_module(
    input [3:0] A,
    input [3:0] B,
    input [2:0] OP,
    input clk, // Added clk as an input
    output reg [3:0] result
);reg [3:0] alu_out1;
reg [3:0] alu_out2;

always @(*) begin
    case(OP)
        3'b000: alu_out1 = A + B; // addition
        3'b001: alu_out1 = A - B; // subtraction
        3'b010: alu_out1 = A & B; // bitwise AND
        3'b011: alu_out1 = A | B; // bitwise OR
        3'b100: alu_out1 = A ^ B; // bitwise XOR
        3'b101: alu_out1 = {A[2:0], 1'b0}; // arithmetic shift left
        default: alu_out1 = 4'b0; // default case
    endcase
end

always @(posedge clk) begin
    alu_out2 <= alu_out1; // Registering alu_out1 at positive edge of clk
    result <= alu_out2;   // Registering alu_out2 as the result
end

endmodule