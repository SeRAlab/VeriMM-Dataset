module binary_to_dac (
    input [7:0] binary_in,
    output [7:0] dac_out
);
    assign dac_out = binary_in; // Direct mapping for this simple DAC
endmodule