module ALU_16bit (
    input [15:0] A,
    input [15:0] B,
    input [2:0] ALU_control,
    output reg [15:0] ALU_result,
    output reg comparison_flag
);
    always @(*) begin
        case (ALU_control)
            3'b000: ALU_result = A + B;      // Addition
            3'b001: ALU_result = A - B;      // Subtraction
            3'b010: ALU_result = A & B;      // AND
            3'b011: ALU_result = A | B;      // OR
            3'b100: ALU_result = A ^ B;      // XOR
            3'b101: ALU_result = A << 1;     // Shift Left
            3'b110: ALU_result = A >> 1;     // Shift Right
            3'b111: begin                     // Comparison
                comparison_flag = (A < B) ? 1 : 0;
                ALU_result = 16'b0;           // Output zero for comparison
            end
            default: begin
                ALU_result = 16'b0;           // Default case
                comparison_flag = 1'b0;
            end
        endcase
    end
endmodule