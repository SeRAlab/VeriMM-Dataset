module top_module(clk,instr,oinstr);input [15:0] instr;
    input clk;
    output reg [31:0] oinstr;
always @(*)
begin
 oinstr = instr[15] ? ({16'b1111111111111111,instr[15:0]}) :  ({16'b0000000000000000,instr[15:0]});  
    end
    
endmodule