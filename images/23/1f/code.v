module gpio_controller (
    input wire [2:0] in_pins,
    input wire enable,
    output wire [2:0] out_pins
);

assign out_pins = enable ? in_pins : 3'b000;

endmodule