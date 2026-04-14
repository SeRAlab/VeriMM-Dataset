module ALU_8bit (
    input [7:0] A,
    input [7:0] B,
    input [2:0] ALUControl,
    output reg [7:0] Result,
    output reg Overflow
);
    
    always @(*) begin
        Overflow = 0; // Default overflow
        case (ALUControl)
            3'b000: begin // ADD
                {Overflow, Result} = A + B;
            end
            3'b001: begin // SUBTRACT
                {Overflow, Result} = A - B;
            end
            3'b010: begin // AND
                Result = A & B;
            end
            3'b011: begin // OR
                Result = A | B;
            end
            3'b100: begin // XOR
                Result = A ^ B;
            end
            3'b101: begin // NAND
                Result = ~(A & B);
            end
            3'b110: begin // NOR
                Result = ~(A | B);
            end
            3'b111: begin // NOT
                Result = ~A;
            end
            default: begin
                Result = 8'b00000000;
            end
        endcase
    end
endmodule