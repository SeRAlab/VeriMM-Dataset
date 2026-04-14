module top_module(
        input  [7:0]    iDTDOU,
        input  [7:0]    iSFRMX,
        input  [7:0]    iALOUT,
        input  [7:0]    iMULRG,
        input  [1:0]    iSGPRI,
        output [7:0]    oGPRDI
    );wire [7:0]      wGPRMX[7:0];
    assign oGPRDI = wGPRMX[iSGPRI];
    
    assign wGPRMX[0] = iDTDOU;
    assign wGPRMX[1] = iSFRMX;
    assign wGPRMX[2] = iALOUT;
    assign wGPRMX[3] = iMULRG;
    
endmodule