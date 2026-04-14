module ALU_8bit (  
    input [7:0] A,  
    input [7:0] B,  
    input [2:0] opcode,  
    output reg [7:0] result,  
    output reg carry_out  
);  
    always @(*) begin  
        case (opcode)  
            3'b000: begin // AND  
                result = A & B;  
                carry_out = 0;  
            end  
            3'b001: begin // OR  
                result = A | B;  
                carry_out = 0;  
            end  
            3'b010: begin // XOR  
                result = A ^ B;  
                carry_out = 0;  
            end  
            3'b011: begin // ADD  
                {carry_out, result} = A + B;  
            end  
            3'b100: begin // SUB  
                {carry_out, result} = A - B;  
            end  
            default: begin  
                result = 8'b00000000;  
                carry_out = 0;  
            end  
        endcase  
    end  
endmodule