module ALU_16bit(  
    input [15:0] A,  
    input [15:0] B,  
    input [3:0] opcode,  
    output reg [15:0] result,  
    output reg overflow  
);  
    always @(*) begin  
        overflow = 0;  
        case (opcode)  
            4'b0000: begin // ADD  
                {overflow, result} = A + B;  
            end  
            4'b0001: begin // SUBTRACT  
                {overflow, result} = A - B;  
            end  
            4'b0010: begin // AND  
                result = A & B;  
            end  
            4'b0011: begin // OR  
                result = A | B;  
            end  
            4'b0100: begin // XOR  
                result = A ^ B;  
            end  
            4'b0101: begin // NOT  
                result = ~A;  
            end  
            4'b0110: begin // NAND  
                result = ~(A & B);  
            end  
            4'b0111: begin // NOR  
                result = ~(A | B);  
            end  
            4'b1000: begin // XNOR  
                result = ~(A ^ B);  
            end  
            4'b1001: begin // SHIFT LEFT  
                result = A << 1;  
            end  
            4'b1010: begin // SHIFT RIGHT  
                result = A >> 1;  
            end  
            default: begin  
                result = 16'b0;  
            end  
        endcase  
    end  
endmodule