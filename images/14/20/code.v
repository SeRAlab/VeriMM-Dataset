module alu_16bit (  
    input [15:0] A,  
    input [15:0] B,  
    input [1:0] Ctrl,  
    output reg [15:0] Result  
);  
    always @(*) begin  
        case (Ctrl)  
            2'b00: Result = A + B;       // Addition  
            2'b01: Result = A - B;       // Subtraction  
            2'b10: Result = A & B;       // Bitwise AND  
            default: Result = 16'b0;      // Default case (not necessary but safe)  
        endcase  
    end  
endmodule