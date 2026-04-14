module top_module(
            input [31:0] rsd, 
            input [31:0] rtd, 
            input [31:0] WrtBackData, 
            input [31:0] extImm,
            input [4:0]  shamt,
            input fwRs, 
            input fwRt, 
            input sel_shamt, 
            input sel_imm,
            output [31:0] busA, 
            output [31:0] busB,
            output [31:0] FwRsd,
            output [31:0] FwRtd
);assign FwRsd = (fwRs == 1) ? WrtBackData : rsd;
    assign FwRtd = (fwRt == 1) ? WrtBackData : rtd; 
    
    assign busA  = (sel_shamt == 1) ? {27'b0, shamt} : FwRsd; 
    assign busB  = (sel_imm == 1) ? extImm : FwRtd; 
    

endmodule