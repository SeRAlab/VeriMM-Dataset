module gpio_controller (
    input wire [4:0] pin_select,
    input wire set_clear, // 1 to set, 0 to clear
    input wire clk,
    output reg [4:0] gpio_state
);

    initial begin
        gpio_state = 5'b00000; // initial state of GPIO pins
    end

    always @(posedge clk) begin
        if (set_clear) begin
            gpio_state[pin_select] <= 1'b1; // set pin
        end else begin
            gpio_state[pin_select] <= 1'b0; // clear pin
        end
    end
endmodule