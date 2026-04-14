module top_module(input IDSel, input [31:0] PC, ALUOutR, output reg [31:0] Adr);always@(*)begin
if(IDSel == 1)
Adr <= ALUOutR;
if(IDSel == 0) 

Adr <= PC;

end 
endmodule