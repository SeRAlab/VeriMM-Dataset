module GPIO_Controller (
    input wire [3:0] gpio_data,
    input wire enable,
    input wire clk,
    output reg [3:0] gpio_output
);
    
    always @(posedge clk) begin
        if (enable) begin
            gpio_output <= gpio_data; // Latch the data
        end
        // If enable is low, retain previous value of gpio_output
    end
endmodule