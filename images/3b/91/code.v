module gpio_controller (
    input wire [4:0] gpio_in,
    input wire control,
    input wire clk,
    output reg [4:0] gpio_out
);
    always @(posedge clk) begin
        if (control) begin
            gpio_out <= gpio_out; // Read state
        end else begin
            gpio_out <= gpio_in; // Write new state
        end
    end
endmodule