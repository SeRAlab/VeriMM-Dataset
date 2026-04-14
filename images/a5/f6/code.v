module top_module(
    Y ,
    A1,
    A2,
    A3,
    B1
);output Y ;
    input  A1;
    input  A2;
    input  A3;
    input  B1;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    wire [3:0] input_signals;
    assign input_signals = {A1, A2, A3, B1};

    assign Y = (input_signals == 4'b0000) ? 1'b0 :
               (input_signals == 4'b1111) ? 1'b1 :
               (input_signals != 4'b0000) ? 1'b1 :
               (input_signals != 4'b1111) ? 1'b0 :
               1'bx;

endmodule