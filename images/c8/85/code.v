module sky130_fd_sc_ls__dlymetal6s6s (
    input  A,
    output X
);

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    // Output logic
    assign X = A;

endmodule