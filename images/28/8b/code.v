module gpio_controller (
    input wire clk,
    input wire reset,
    input wire data,
    output reg gpio_out
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            gpio_out <= 1'b0; // Initialize GPIO to low
        end else begin
            gpio_out <= data; // Set GPIO state based on data input
        end
    end
endmodule