module gpio_controller (
    input wire clk,
    input wire reset,
    input wire write_enable,
    input wire [7:0] gpio_in,
    input wire read_enable,
    output reg [7:0] gpio_out
);

    reg [7:0] gpio_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            gpio_reg <= 8'b0;
            gpio_out <= 8'b0;
        end else begin
            if (write_enable) begin
                gpio_reg <= gpio_in;
            end
            if (read_enable) begin
                gpio_out <= gpio_reg;
            end
        end
    end
endmodule