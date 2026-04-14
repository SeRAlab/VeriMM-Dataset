module top_module(
    X,
    A1,
    A2,
    A3,
    B1,
    B2
);output X;
    input A1;
    input A2;
    input A3;
    input B1;
    input B2;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB;
    supply0 VNB;

    wire or_input;
    wire and_output;

    assign or_input = A3 | B1 | B2;
    assign and_output = A1 & A2;

    assign X = and_output & or_input;
    
endmodule