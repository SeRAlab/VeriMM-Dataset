module gpio_controller (
    input clk,
    input reset,
    input [3:0] buttons,  // 4 buttons
    output reg [3:0] leds  // 4 LEDs
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            leds <= 4'b0000;  // Turn off all LEDs on reset
        end else begin
            leds <= buttons;  // Output the state of the buttons to the LEDs
        end
    end
endmodule