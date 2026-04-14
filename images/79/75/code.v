module top_module(
        input           iAZERO,
        input  [31:0]   iINST,
        
        output          oWRDTA,
        output          oWRGPR,
        output          oWRSFR,
        output          oWRMLR,
        output [1:0]    oSGPRI,
        output [2:0]    oSAOUT,
        output          oUAZRO,
        output          oUIMMB,
        output          oPCJEN,
        output [3:0]    oSREGA,
        output [3:0]    oSREGB,
        output [3:0]    oSSFRR,
        output [7:0]    oIMMBV
    );wire   wJZ;
    wire   wJNZ;
    assign wJZ    = iINST[27];
    assign wJNZ   = iINST[28];
    
    assign oWRDTA = iINST[16];
    assign oWRGPR = iINST[17];
    assign oWRSFR = iINST[18];
    assign oWRMLR = iINST[19];
    assign oSGPRI = iINST[21:20];
    assign oSAOUT = iINST[24:22];
    assign oUAZRO = iINST[25];
    assign oUIMMB = iINST[26];
    assign oPCJEN = (wJZ && iAZERO) || (wJNZ && ~iAZERO);
    
    assign oSREGA = iINST[15:12];
    assign oSREGB = iINST[11:8];
    assign oSSFRR = iINST[11:8];
    assign oIMMBV = iINST[7:0];
    
endmodule