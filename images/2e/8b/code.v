module gpio_controller (
    input wire clk,
    input wire enable,
    input wire [4:0] gpio_in,
    output reg [4:0] gpio_out
);

    reg [4:0] input_reg;

    always @(posedge clk) begin
        if (enable) begin
            input_reg <= gpio_in;
            gpio_out <= input_reg; // Mirror the input to output
        end
    end
endmodule