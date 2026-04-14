module power_supply (
    input VPWR,
    input VGND,
    output VPB,
    output VNB
);

    // Define voltage levels
    parameter VDD = 1;
    parameter VSS = 0;
    parameter VBAT = 1.5;

    // Define internal signals
    wire VBATP;
    wire VBATN;

    // Connect voltage supplies
    assign VBATP = VPWR ? VBAT : VSS;
    assign VBATN = VGND ? VBAT : VSS;

    // Ensure VPB is higher than VNB
    assign VPB = VBATP;
    assign VNB = VBATN;

endmodule