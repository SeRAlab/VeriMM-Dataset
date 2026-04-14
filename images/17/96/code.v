module ALU_32bit (  
    input [31:0] A,  
    input [31:0] B,  
    input [2:0] control,  
    output reg [31:0] result,  
    output reg overflow  
);  
    always @(*) begin  
        case (control)  
            3'b000: begin // ADD  
                {overflow, result} = A + B;  
            end  
            3'b001: begin // SUB  
                {overflow, result} = A - B;  
            end  
            3'b010: begin // AND  
                result = A & B;  
                overflow = 0;  
            end  
            3'b011: begin // OR  
                result = A | B;  
                overflow = 0;  
            end  
            3'b100: begin // XOR  
                result = A ^ B;  
                overflow = 0;  
            end  
            default: begin  
                result = 32'b0;  
                overflow = 0;  
            end  
        endcase  
    end  
endmodule