module GPIO_Controller (
    input wire clk,
    input wire reset,
    input wire [7:0] gpio_in,
    output reg [7:0] gpio_out
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            gpio_out <= 8'b0; // Reset output to 0
        end else begin
            gpio_out <= gpio_in; // Latch input to output
        end
    end

endmodule