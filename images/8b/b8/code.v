module top_module(
    Y,
    A1,
    A2,
    A3,
    A4,
    B1
);output Y;
    input A1, A2, A3, A4, B1;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB;
    supply0 VNB;

    // Use a simple AND gate and invert B1 for active-low enable functionality
    wire enable;

    // Invert B1 for the enable signal
    not u_inv(enable, B1);

    // Output Y is high when enable is active and all A inputs are high
    assign Y = enable & A1 & A2 & A3 & A4;

endmodule