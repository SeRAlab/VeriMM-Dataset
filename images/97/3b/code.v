module top_module(
    input A,
    input B,
    input C,
    input D,
    output X
);wire w1, w2, w3, w4, w5;
    
    // Replace sky130_fd_sc_hs__xnor3 with standard XNOR gate
    xnor u1 (
        w1,
        A,
        B,
        C
    );
    
    xnor u2 (
        w2,
        w1,
        D
    );
    
    xnor u3 (
        w3,
        w2,
        C
    );
    
    xnor u4 (
        w4,
        w3,
        D
    );
    
    xnor u5 (
        w5,
        w4,
        w4
    );
    
    xnor u6 (
        X,
        w5,
        w5
    );
    
    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;

endmodule