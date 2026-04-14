module ALU_8bit (  
    input [7:0] A,  
    input [7:0] B,  
    input [2:0] control,  
    output reg [7:0] result,  
    output reg zero_flag  
);  
    always @(*) begin  
        case(control)  
            3'b000: result = A & B; // AND  
            3'b001: result = A | B; // OR  
            3'b010: result = A + B; // ADD  
            3'b011: result = A - B; // SUBTRACT  
            3'b100: result = A ^ B; // XOR  
            default: result = 8'b00000000;  
        endcase  
        zero_flag = (result == 8'b00000000) ? 1'b1 : 1'b0;  
    end  
endmodule