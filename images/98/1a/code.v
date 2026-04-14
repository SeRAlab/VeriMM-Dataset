module top_module(
    Y,
    A,
    B,
    S
);output Y;
    input A;
    input B;
    input S;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    // Select output based on S signal
    assign Y = (S == 1) ? A : B;

endmodule