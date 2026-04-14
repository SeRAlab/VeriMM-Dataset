module top_module(A, B, RES);parameter  WIDTHA = 8;
    parameter  WIDTHB = 4;
    input   [WIDTHA-1:0]         A;
    input   [WIDTHB-1:0]         B;
    output  [WIDTHA+WIDTHB-1:0]  RES;
    
    assign RES = A * B;
endmodule