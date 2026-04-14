module ALU (  
    input [31:0] A,  
    input [31:0] B,  
    input [2:0] control,  
    output reg [31:0] result,  
    output reg carry_out  
);  

always @(*) begin  
    carry_out = 0;  
    case (control)  
        3'b000: begin  // Addition  
            {carry_out, result} = A + B;  
        end  
        3'b001: begin  // Subtraction  
            {carry_out, result} = A - B;  
        end  
        3'b010: begin  // AND  
            result = A & B;  
        end  
        3'b011: begin  // OR  
            result = A | B;  
        end  
        3'b100: begin  // XOR  
            result = A ^ B;  
        end  
        default: result = 32'b0;  
    endcase  
end  
endmodule