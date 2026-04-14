module ALU_16bit (  
    input [15:0] A,  
    input [15:0] B,  
    input [2:0] control,  
    output reg [15:0] result  
);  

always @(*) begin  
    case (control)  
        3'b000: result = A + B; // ADD  
        3'b001: result = A - B; // SUB  
        3'b010: result = A & B; // AND  
        3'b011: result = A | B; // OR  
        3'b100: result = A ^ B; // XOR  
        default: result = 16'b0;  
    endcase  
end  
endmodule