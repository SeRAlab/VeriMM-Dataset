module ALU_16bit (
    input [15:0] A,
    input [15:0] B,
    input [1:0] Op,
    output reg [15:0] Result,
    output reg CarryOut
);
    always @(*) begin
        case (Op)
            2'b00: {CarryOut, Result} = A + B;               // Addition
            2'b01: {CarryOut, Result} = A - B;               // Subtraction
            2'b10: begin 
                Result = A & B; 
                CarryOut = 0; 
            end                                   // Bitwise AND
            default: begin 
                Result = 16'b0; 
                CarryOut = 0; 
            end
        endcase
    end
endmodule