module gpio_controller (
    input wire clk,
    input wire reset,
    input wire write_en,
    input wire gpio_in,
    output reg gpio_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            gpio_out <= 1'b0; // Set GPIO to low on reset
        end else if (write_en) begin
            gpio_out <= gpio_in; // Write input to GPIO output
        end
    end
endmodule