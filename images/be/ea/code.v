module top_module(
    input [7:0] A,
    input [7:0] B,
    input sel,
    output [7:0] Y
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB;
    supply0 VNB;

    // Using a behavioral description for the mux
    assign Y = (sel == 1'b1) ? B : A;

endmodule