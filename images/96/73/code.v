module top_module();// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    // Module logic
    assign VPWR = 1'b1;
    assign VGND = 1'b0;
    assign VPB = 1'b1;
    assign VNB = 1'b0;

endmodule