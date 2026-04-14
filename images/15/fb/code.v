module gpio_controller (
    input wire clk,
    input wire [3:0] gpio_input,   // 4 input GPIO pins
    input wire [3:0] gpio_out,      // 4 output GPIO pins
    output reg [3:0] gpio_state_out  // current state of output GPIO pins
);

    always @(posedge clk) begin
        gpio_state_out <= gpio_out; // Update output state on clock edge
    end

endmodule