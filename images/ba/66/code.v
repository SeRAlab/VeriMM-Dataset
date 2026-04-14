module top_module(
    input a,
    input b,
    input c,
    input d,
    output x
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB;
    supply0 VNB;

    // Implementing a 4-input OR gate using basic Verilog logic
    assign x = a | b | c | d;

endmodule