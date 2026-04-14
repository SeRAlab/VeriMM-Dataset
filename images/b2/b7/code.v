module top_module(
    X,
    A0,
    A1,
    A2,
    A3,
    S0,
    S1
);output X;
    input A0;
    input A1;
    input A2;
    input A3;
    input S0;
    input S1;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB;
    supply0 VNB;

    wire out0, out1, out2, out3;

    // Instantiating a generic 4-input multiplexer
    assign out0 = A0;  // Select line S0 and S1 determine the output
    assign out1 = A1; 
    assign out2 = A2;
    assign out3 = A3;

    assign X = (~S1 & ~S0) ? out0 :
               (~S1 &  S0) ? out1 :
               ( S1 & ~S0) ? out2 :
               ( S1 &  S0) ? out3 : 1'b0;  // Default case is '0'

endmodule