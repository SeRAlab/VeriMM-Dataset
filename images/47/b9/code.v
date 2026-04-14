module top_module(
    Z   ,
    D   ,
    S   ,
    VPWR,
    VGND,
    VPB ,
    VNB
);output       Z   ;
    input  [7:0] D   ;
    input  [2:0] S   ;
    input        VPWR;
    input        VGND;
    input        VPB ;
    input        VNB ;

    wire [1:0] sel;
    assign sel = S[1:0];

    wire out1, out2;

    // Simplified 4-to-1 MUX for first half (D[3:0])
    assign out1 = (sel == 2'b00) ? D[0] :
                  (sel == 2'b01) ? D[1] :
                  (sel == 2'b10) ? D[2] : D[3];

    // Simplified 4-to-1 MUX for second half (D[7:4])
    assign out2 = (sel == 2'b00) ? D[4] :
                  (sel == 2'b01) ? D[5] :
                  (sel == 2'b10) ? D[6] : D[7];

    // Select between out1 and out2 based on S[2]
    assign Z = S[2] ? out2 : out1;

endmodule