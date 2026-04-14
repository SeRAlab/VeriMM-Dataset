module gpio_controller (
    input wire [3:0] gpio_in,
    input wire latch,
    input wire clk,
    output reg [3:0] gpio_out
);

    always @(posedge clk) begin
        if (latch) begin
            gpio_out <= gpio_in;
        end
    end

endmodule