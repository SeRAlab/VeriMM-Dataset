module top_module();// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    // assign values to the supply signals
    assign VPWR = 1;
    assign VGND = 0;
    assign VPB = 1.2;
    assign VNB = -1.2;

endmodule