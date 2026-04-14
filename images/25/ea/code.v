module gpio_controller (
    input wire clk,
    input wire reset,
    input wire [4:0] gpio_in,
    input wire toggle,
    output reg [4:0] gpio_out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        gpio_out <= 5'b00000;
    end else begin
        if (toggle) begin
            gpio_out <= ~gpio_out; // Toggle the output
        end else begin
            gpio_out <= gpio_in; // Set output to input value
        end
    end
end

endmodule