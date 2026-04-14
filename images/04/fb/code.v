module alu_64bit (  
    input [63:0] a,  
    input [63:0] b,  
    input [2:0] ctrl,  
    output reg [63:0] result  
);  
    always @(*) begin  
        case (ctrl)  
            3'b000: result = a + b;         // Addition  
            3'b001: result = a - b;         // Subtraction  
            3'b010: result = a & b;         // Bitwise AND  
            3'b011: result = a | b;         // Bitwise OR  
            3'b100: result = a ^ b;         // Bitwise XOR  
            default: result = 64'b0;        // Default case  
        endcase  
    end  
endmodule