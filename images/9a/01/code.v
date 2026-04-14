module top_module(instout, pcout, instruction, pc, clock);output reg[31:0] instout, pcout;
input  [31:0] instruction,pc;
input clock;
 
always@(posedge clock)
begin
instout=instruction;
pcout=pc;
end

endmodule