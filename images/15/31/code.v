module ALU_16bit (  
    input [15:0] A,  
    input [15:0] B,  
    input [2:0] ALU_control,  
    output reg [15:0] ALU_result  
);  
    always @(*) begin  
        case (ALU_control)  
            3'b000: ALU_result = A & B; // AND  
            3'b001: ALU_result = A | B; // OR  
            3'b010: ALU_result = A + B; // ADD  
            3'b011: ALU_result = A - B; // SUB  
            3'b100: ALU_result = A ^ B; // XOR  
            default: ALU_result = 16'b0;  
        endcase  
    end  
endmodule