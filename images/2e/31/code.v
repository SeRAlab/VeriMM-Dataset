module DAC_Controller (
    input [15:0] digital_input,
    output [15:0] analog_output
);
    assign analog_output = (digital_input * 5) / 65535; // 5V * (D / 65535)
endmodule