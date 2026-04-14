module top_module(
    input  A      ,
    output X      ,
    input  SLEEP_B
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    assign VPWR = (SLEEP_B) ? 1 : 0;
    assign VPB = (SLEEP_B) ? 1 : 0;
    assign VGND = (SLEEP_B) ? 0 : 1;
    assign VNB = (SLEEP_B) ? 0 : 1;

    assign X = A;

endmodule