module top_module(R2,Q2,R3);input [15:0]R2;
    input [15:0]Q2;
    output [15:0]R3;
    
    assign R3[15:0] = R2[15:0] | ( {Q2[12:0],Q2[15:13]} & {R2[7:0],R2[15:8]} ) ;endmodule