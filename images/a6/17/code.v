module top_module(reg0, reg1, regRd0, regRd1, regFw, regIndex0, regIndex1,
                        regIndexWr, wrEn);input [31:0]    regRd0, regRd1,
                    regFw;
    input [3:0]     regIndex0, regIndex1, regIndexWr;
    input           wrEn;

    output [31:0]   reg0, reg1;

    assign reg0 = regIndex0 == regIndexWr && wrEn ? regFw : regRd0;
    assign reg1 = regIndex1 == regIndexWr && wrEn ? regFw : regRd1;

endmodule