module gpio_controller (
    input wire clk,
    input wire reset,
    input wire latch,
    input wire [3:0] gpio_in,
    output reg [3:0] gpio_out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        gpio_out <= 4'b0000;
    end else if (latch) begin
        gpio_out <= gpio_out; // hold the last state
    end else begin
        gpio_out <= gpio_in; // update output with input
    end
end

endmodule