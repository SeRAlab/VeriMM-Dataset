module power_gating (
    input wire PC, // Power control signal
    input wire D,  // Data input
    output wire Y  // Output
);
assign Y = PC ? D : 1'b0; // If PC is high, output D, otherwise output 0
endmodule