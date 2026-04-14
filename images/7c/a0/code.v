module top_module(out,Sin,A,B,C,D);input wire A,B,C,D;
    input wire[1:0] Sin;
    output wire out;

    assign out= ((~Sin[0])&&(~Sin[1])&&A ) || ((Sin[0])&&(~Sin[1])&&B) || ((~Sin[0])&&(Sin[1])&&C) || ((Sin[0])&&(Sin[1])&&D);endmodule