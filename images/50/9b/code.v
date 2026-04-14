module top_module(pc, inst);input [31:0] pc;
    reg [15:0] temp_pc;
    output reg [31:0]inst;

    reg [7:0]inst_mem_reg[65535:0];

    always@(pc)
    begin
        temp_pc = pc[15:0];
        inst = {inst_mem_reg[temp_pc],inst_mem_reg[temp_pc+1],inst_mem_reg[temp_pc+2],inst_mem_reg[temp_pc+3]};
    end

    
    
    


endmodule