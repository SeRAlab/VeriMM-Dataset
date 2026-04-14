module top_module();// Module supplies
    supply1 KAPWR;
    supply1 VPWR ;
    supply0 VGND ;
    supply1 VPB  ;
    supply0 VNB  ;

    // Generate five different supply voltages
    assign KAPWR = 1'b1;
    assign VPWR = 1'b1;
    assign VGND = 1'b0;
    assign VPB = 1'b1;
    assign VNB = 1'b0;
    
endmodule