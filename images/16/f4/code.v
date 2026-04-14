module gpio_controller (
    input clk,
    input reset,
    input set_pin,
    input pin_value,
    output reg gpio_pin
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            gpio_pin <= 0;
        end else if (set_pin) begin
            gpio_pin <= pin_value;
        end
    end
endmodule