module ALU_32bit (  
    input [31:0] A,  
    input [31:0] B,  
    input [2:0] opcode,  
    output reg [31:0] result,  
    output reg zero  
);  
    always @(*) begin  
        case(opcode)  
            3'b000: result = A + B;  
            3'b001: result = A - B;  
            3'b010: result = A & B;  
            3'b011: result = A | B;  
            3'b100: result = A ^ B;  
            3'b101: result = ~(A & B);  
            3'b110: result = ~(A | B);  
            3'b111: result = ~(A ^ B);  
            default: result = 32'b0;  
        endcase  
        zero = (result == 32'b0) ? 1'b1 : 1'b0;  
    end  
endmodule