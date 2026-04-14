module ALU_32bit (  
    input [31:0] A,  
    input [31:0] B,  
    input [1:0] ALU_Control,  
    output reg [31:0] ALU_Result  
);  
    always @(*) begin  
        case(ALU_Control)  
            2'b00: ALU_Result = A + B;        // Addition  
            2'b01: ALU_Result = A - B;        // Subtraction  
            2'b10: ALU_Result = A & B;        // Bitwise AND  
            default: ALU_Result = 32'b0;      // Default case  
        endcase  
    end  
endmodule