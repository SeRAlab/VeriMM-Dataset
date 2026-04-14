module gpio_controller(
    input clk,
    input [2:0] pin_num,     // GPIO pin number (0 to 7)
    input [1:0] mode,        // Mode: 00 - Set, 01 - Read
    input pin_value,         // Value to set for the GPIO pin (only valid in Set mode)
    output reg pin_output     // Output value for the Read mode
);
    reg [7:0] gpio_pins;     // 8 GPIO pins

    always @(posedge clk) begin
        case (mode)
            2'b00: begin // Set mode
                gpio_pins[pin_num] <= pin_value;
            end
            2'b01: begin // Read mode
                pin_output <= gpio_pins[pin_num];
            end
            default: ;
        endcase
    end
endmodule