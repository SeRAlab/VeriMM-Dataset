module ALU_16bit (  
    input [15:0] A,  
    input [15:0] B,  
    input [2:0] ALU_ctrl,  
    output reg [15:0] ALU_out  
);  

always @(*) begin  
    case (ALU_ctrl)  
        3'b000: ALU_out = A + B;        // Addition  
        3'b001: ALU_out = A - B;        // Subtraction  
        3'b010: ALU_out = A & B;        // AND  
        3'b011: ALU_out = A | B;        // OR  
        3'b100: ALU_out = A ^ B;        // XOR  
        default: ALU_out = 16'b0;       // Default case (should not happen)  
    endcase  
end  
endmodule