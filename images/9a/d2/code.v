module top_module(
    input [3:0] data, // 4-bit input signals
    input [1:0] sel,  // 2-bit selection signal
    output reg out    // 1-bit output signal
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;

    // Internal wires
    wire inv1_out, inv2_out, and1_out, and2_out, or1_out;

    // Inverter for selection signals
    assign inv1_out = ~sel[1];
    assign inv2_out = ~sel[0];

    // AND operations based on selection and data
    assign and1_out = data[0] & inv1_out & inv2_out; // sel = 00
    assign and2_out = data[1] & inv1_out & sel[0];   // sel = 01
    assign and3_out = data[2] & sel[1] & inv2_out;   // sel = 10
    assign and4_out = data[3] & sel[1] & sel[0];      // sel = 11

    // OR operation to combine the outputs of AND gates
    assign out = and1_out | and2_out | and3_out | and4_out;

endmodule