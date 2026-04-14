module dac_controller (
    input [15:0] digital_in,
    output [15:0] analog_out
);
    assign analog_out = digital_in; // Direct mapping for DAC simulation
endmodule