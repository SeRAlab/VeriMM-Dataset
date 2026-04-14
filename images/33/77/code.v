module gpio_controller(
    input wire clk,
    input wire reset,
    input wire gpio_input,
    output reg gpio_output
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            gpio_output <= gpio_output; // Retain previous state
        end else begin
            gpio_output <= gpio_input; // Update output based on input
        end
    end
endmodule