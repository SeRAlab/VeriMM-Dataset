module gpio_controller(
    input wire clk,
    input wire write_enable,
    input wire read_enable,
    input wire gpio_in,
    output reg gpio_out
);
    reg gpio_state;

    always @(posedge clk) begin
        if (write_enable) begin
            gpio_state <= gpio_in;
        end
        if (read_enable) begin
            gpio_out <= gpio_state;
        end
    end
endmodule