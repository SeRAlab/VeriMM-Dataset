module top_module(
    X,
    A
);output reg [3:0] X;
    input [3:0] A;

    // Voltage supply signals
    supply1 KAPWR;
    supply1 VPWR ;
    supply0 VGND ;
    supply1 VPB  ;
    supply0 VNB  ;

    always @ (A) begin
        X = (2**3 * A[3]) + (2**2 * A[2]) + (2**1 * A[1]) + (2**0 * A[0]);
    end

endmodule