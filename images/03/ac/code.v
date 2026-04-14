module gpio_controller (
    input clk,
    input reset,
    input [3:0] gpio_in,
    input [3:0] gpio_cmd,
    output reg [3:0] gpio_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            gpio_out <= 4'b0000; // Reset GPIO pins to low
        end else begin
            case (gpio_cmd)
                4'b0001: gpio_out <= gpio_in; // Set GPIO pins
                4'b0010: gpio_out <= 4'b0000; // Clear GPIO pins
                4'b0011: gpio_out <= ~gpio_out; // Toggle GPIO pins
                default: gpio_out <= gpio_out; // No operation
            endcase
        end
    end
endmodule