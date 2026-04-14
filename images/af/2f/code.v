module top_module(
    rt_addr_IDEX, 
    rs_addr_IDEX, 
    rd_addr_EXMEM, 
    rd_addr_MEMWB, 
    regwrite_EXMEM, 
    regwrite_MEMWB, 
    forwardA, 
    forwardB
);input [4:0] rt_addr_IDEX;
    input [4:0] rs_addr_IDEX;
    input [4:0] rd_addr_EXMEM;
    input [4:0] rd_addr_MEMWB;
    input regwrite_EXMEM;
    input regwrite_MEMWB;
    output [1:0] forwardA;
    output [1:0] forwardB;

    // Check if the current instruction in the EXMEM pipeline stage writes to a register and the destination register matches the source register of the current instruction in the IDEX pipeline stage
    assign forwardA[1] = (regwrite_EXMEM && (rd_addr_EXMEM == rt_addr_IDEX)) ? 1 : 0;

    // Check if the current instruction in the MEMWB pipeline stage writes to a register and the destination register matches the source register of the current instruction in the IDEX pipeline stage
    assign forwardA[0] = (regwrite_MEMWB && (rd_addr_MEMWB == rt_addr_IDEX)) ? 1 : 0;

    // Check if the current instruction in the EXMEM pipeline stage writes to a register and the destination register matches the second source register of the current instruction in the IDEX pipeline stage
    assign forwardB[1] = (regwrite_EXMEM && (rd_addr_EXMEM == rs_addr_IDEX)) ? 1 : 0;

    // Check if the current instruction in the MEMWB pipeline stage writes to a register and the destination register matches the second source register of the current instruction in the IDEX pipeline stage
    assign forwardB[0] = (regwrite_MEMWB && (rd_addr_MEMWB == rs_addr_IDEX)) ? 1 : 0;

    // Set both forwardA and forwardB to 0 if no forwarding is required
    assign {forwardA, forwardB} = (forwardA[1:0] != 2'b00 || forwardB[1:0] != 2'b00) ? {forwardA, forwardB} : 2'b00;

endmodule