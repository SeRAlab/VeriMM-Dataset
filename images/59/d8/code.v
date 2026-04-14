module top_module(
    output X,
    input A1,
    input A2,
    input [1:0] B1
);wire a1_and_a2;
    wire b1_bit0;
    wire b1_bit1;

    assign a1_and_a2 = A1 & A2;
    assign b1_bit0 = B1[0];
    assign b1_bit1 = B1[1];

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    // Ensure that the referenced module definition is included
    // If not, replace 'sky130_fd_sc_hvl__o21a_1' with a valid module or remove it as necessary
    // sky130_fd_sc_hvl__o21a_1 base (  // Uncomment and use a valid module if available
    //     .X(X),
    //     .A1(A1),
    //     .A2(A2),
    //     .B1(B1)
    // );

    assign X = (A1 & ~A2) | (~A1 & A2 & b1_bit1) | (a1_and_a2 & b1_bit0) | (a1_and_a2 & b1_bit1);

endmodule