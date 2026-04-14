module top_module(
    output Y ,
    input  A1,
    input  A2,
    input  A3,
    input  A4,
    input  B1
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;

    // Implementing the 4-input AND gate with an additional input signal B1
    assign Y = (A1 & A2 & A3 & A4 & B1);

endmodule