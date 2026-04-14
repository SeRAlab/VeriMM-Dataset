module top_module(
    input      [  7 : 0 ] irqNumber,
    input                 irqDetected,
    
    output     [ 17 : 1 ] EIC_Offset,
    output     [  3 : 0 ] EIC_ShadowSet,
    output     [  7 : 0 ] EIC_Interrupt,
    output     [  5 : 0 ] EIC_Vector
);assign EIC_ShadowSet = 4'b0;

    
    
    assign EIC_Interrupt = irqDetected ? irqNumber + 1  : 8'b0;

    `ifdef EIC_USE_EXPLICIT_VECTOR_OFFSET

        
        
        
        
        

        parameter HANDLER_BASE  = 17'h100;
        parameter HANDLER_SHIFT = 4;

        assign EIC_Offset    = HANDLER_BASE + (irqNumber << HANDLER_SHIFT);
        assign EIC_Vector    = 6'b0;
    `else

        
        
        
        
        

        assign EIC_Offset    = 17'h0;
        assign EIC_Vector    = irqNumber[5:0];
    `endif

endmodule