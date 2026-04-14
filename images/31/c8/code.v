module alu64 (
    input [63:0] a,
    input [63:0] b,
    input [2:0] op,  
    output reg [63:0] result  
);  
    always @(*) begin  
        case (op)  
            3'b000: result = a + b;          // ADD  
            3'b001: result = a - b;          // SUBTRACT  
            3'b010: result = a & b;          // AND  
            3'b011: result = a | b;          // OR  
            3'b100: result = a ^ b;          // XOR  
            default: result = 64'b0;         // Default case  
        endcase  
    end  
endmodule