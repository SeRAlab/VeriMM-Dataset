module ALU (
    input [31:0] A,
    input [31:0] B,
    input [2:0] ALUControl,
    output reg [31:0] ALUResult,
    output reg CarryOut
);
    always @(*) begin
        case (ALUControl)
            3'b000: begin // Addition
                {CarryOut, ALUResult} = A + B;
            end
            3'b001: begin // Subtraction
                {CarryOut, ALUResult} = A - B;
            end
            3'b010: begin // AND
                ALUResult = A & B;
                CarryOut = 1'b0;
            end
            3'b011: begin // OR
                ALUResult = A | B;
                CarryOut = 1'b0;
            end
            3'b100: begin // XOR
                ALUResult = A ^ B;
                CarryOut = 1'b0;
            end
            default: begin
                ALUResult = 32'b0;
                CarryOut = 1'b0;
            end
        endcase
    end
endmodule