module top_module(
    input [3:0] A,
    output [3:0] X
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    assign X = A + 4'b0011;

endmodule