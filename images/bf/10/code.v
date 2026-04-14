module top_module(
    input A,
    input B,
    output Y
);// Module supplies
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB;
    supply0 VNB;

    // Local signals
    wire and_out_Y;

    // AND gate implementation
    and and0 (and_out_Y, A, B);

    // Output assignment
    assign Y = and_out_Y;

endmodule