module top_module(
    addr_i, 
    instr_o
);input   [31:0]      addr_i;
output  [31:0]      instr_o;


reg     [127:0]     memory  [0:31];

assign  instr_o = memory[addr_i>>2];  

endmodule