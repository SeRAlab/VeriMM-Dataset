module top_module(input [15:0] Imm16,input [1:0] ExtendI,output reg [31:0] Imm32);always @(*)begin 
 case(ExtendI) 
 2'b00:Imm32={16'h0000,Imm16}; 
 2'b01:Imm32 = {{16{Imm16[15]}}, Imm16}; 
 2'b10:Imm32 = {Imm16, 16'h0000}; 
 2'b11:Imm32 = {{16{Imm16[15]}}, Imm16} << 2; 
 endcase 
 end 
 endmodule