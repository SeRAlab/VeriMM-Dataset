module top_module(A0,A1,A2,D0,D1,D2,D3,D4,D5,D6,D7);input  A0,A1,A2;
    output D0,D1,D2,D3,D4,D5,D6,D7;

    assign D0 = ~A2 & ~A1 & ~A0;
    assign D1 = ~A2 & ~A1 & A0;
    assign D2 = ~A2 & A1 & ~A0;
    assign D3 = ~A2 & A1 & A0;
    assign D4 = A2 & ~A1 & ~A0;
    assign D5 = A2 & ~A1 & A0;
    assign D6 = A2 & A1 & ~A0;
    assign D7 = A2 & A1 & A0;endmodule