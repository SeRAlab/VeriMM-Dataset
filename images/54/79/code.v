module top_module(
    a,b,
    opcode,
    resultado
    );input wire [31:0] a,b;
input wire [4:0] opcode;
output reg [31:0] resultado;

always @*
begin
    case (opcode)
    5'b00000: resultado = a + b;   
    5'b00001: resultado = a - b;   
    5'b00010: resultado = a & b;   
    5'b00011: resultado = a | b;   
    
    5'b00101: resultado = a << b;  
    5'b00110: resultado = a >> b;  
    5'b00111: resultado = a * b;   
    5'b01000: resultado = a / b;   
    5'b01001: resultado = 32'b0;   
    5'b01010: resultado = 32'b0;   
    5'b01011: resultado = a + b;   
    5'b01100: resultado = a + b;   
    5'b01101: resultado = a + b;   
    5'b01110: resultado = 32'b0;   
    5'b11111: resultado = 32'b0;   
	 default: resultado = 32'b0;
    endcase
end
endmodule