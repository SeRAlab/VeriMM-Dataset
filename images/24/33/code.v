module ALU_16bit(  
    input [15:0] A,  
    input [15:0] B,  
    input [3:0] control,  
    output reg [15:0] result  
);  
    always @(*) begin  
        case(control)  
            4'b0000: result = A + B;          // Addition  
            4'b0001: result = A - B;          // Subtraction  
            4'b0010: result = A & B;          // Bitwise AND  
            4'b0011: result = A | B;          // Bitwise OR  
            default: result = 16'b0;           // Default case  
        endcase  
    end  
endmodule