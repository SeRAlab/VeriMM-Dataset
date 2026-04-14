module top_module(rt, rd, RegDst, DstReg);input      [4:0] rt;           
    input      [4:0] rd;           
    input            RegDst;       
    output reg [4:0] DstReg;       
    
    always @(*) 
        if (RegDst)
            DstReg <= rd;
        else 
            DstReg <= rt;endmodule