module dac_controller (
    input [23:0] digital_input,
    output [11:0] analog_output
);
    assign analog_output = digital_input >> 12; // Scale down from 24 bits to 12 bits
endmodule