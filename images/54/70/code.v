module top_module(
    input A,
    input B,
    input C,
    input VPB,
    input VPWR,
    input VGND,
    input VNB,
    output Y
);// Create three inverters
    wire invA, invB, invC;
    not (invA, A);
    not (invB, B);
    not (invC, C);

    // Create two NOR gates using the built-in nor primitive
    wire norAB, norABC;
    nor (norAB, invA, invB);
    nor (norABC, norAB, invC);

    // Assign output to norABC
    assign Y = norABC;

endmodule