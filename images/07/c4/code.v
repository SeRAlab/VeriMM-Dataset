module ALU_16bit (  
    input [15:0] A,  
    input [15:0] B,  
    input [2:0] opcode,  
    output reg [15:0] result  
);  
    always @(*) begin  
        case (opcode)  
            3'b000: result = A + B;        // ADD  
            3'b001: result = A - B;        // SUB  
            3'b010: result = A & B;        // AND  
            3'b011: result = A | B;        // OR  
            3'b100: result = A ^ B;        // XOR  
            3'b101: result = ~A;           // NOT A  
            3'b110: result = ~(A & B);     // NAND  
            3'b111: result = ~(A | B);     // NOR  
            default: result = 16'b0;       // Default case  
        endcase  
    end  
endmodule