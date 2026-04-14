module top_module(
    iClock          ,
    iReset          ,
    iSeed           ,
    iSeedEnable     ,
    iShiftEnable    ,
    oData
);input           iClock      ;
    input           iReset      ;
    input   [7:0]   iSeed       ;
    input           iSeedEnable ;
    input           iShiftEnable;
    output  [7:0]   oData       ;
    
    reg     [8:0]   rShiftReg   ;
    wire            wInfeed     ;
    
    always @ (posedge iClock)
        if (iReset)
            rShiftReg <= 9'b0;
        else if (iSeedEnable)
            rShiftReg <= {iSeed[7:0], wInfeed};
        else if (iShiftEnable)
            rShiftReg <= {rShiftReg[7:0], wFeedback};
    
    assign wFeedback = rShiftReg[0] ^ rShiftReg[4] ^ rShiftReg[5] ^ rShiftReg[6] ^ rShiftReg[8];
    assign wInfeed = iSeed[0] ^ iSeed[4] ^ iSeed[5] ^ iSeed[6];
    
    assign oData = rShiftReg[7:0];

endmodule