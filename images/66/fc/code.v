module top_module(
    input wire [4:0] EX_rs,
    input wire [4:0] EX_rt,
    input wire [4:0] MEM_rd,
    input wire [4:0] WB_rd,
    input wire MEM_RegWrite,
    input wire WB_RegWrite,
    output reg [1:0] ForwardA,
    output reg [1:0] ForwardB
    );always @*
        
        
        
        
        
        if (WB_RegWrite && WB_rd && (WB_rd == EX_rs) &&
                ((MEM_rd != EX_rs) || (~MEM_RegWrite)))
            ForwardA = 2'b01;
        
        
        
        
        else if (MEM_RegWrite && MEM_rd && (MEM_rd == EX_rs))
            ForwardA = 2'b10;
        else
            ForwardA = 2'b00;

    always @*
        
        
        
        
        
        if (WB_RegWrite && WB_rd && (WB_rd == EX_rt) &&
                ((MEM_rd != EX_rt) || (~MEM_RegWrite)))
            ForwardB = 2'b01;
        
        
        
        
        else if (MEM_RegWrite && MEM_rd && (MEM_rd == EX_rt))
            ForwardB = 2'b10;
        else
            ForwardB = 2'b00;

endmodule