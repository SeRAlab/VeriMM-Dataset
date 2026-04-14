module top_module(
    output X,
    input A1,
    input A2,
    input B1
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    // Replace with appropriate logic or instantiate a valid module instead of sky130_fd_sc_ms__o21a_2
    // Assuming you want to implement the logical functionality directly
    assign X = (A1 & ~A2 & B1);

endmodule