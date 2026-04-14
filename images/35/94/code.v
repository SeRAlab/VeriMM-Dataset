module gpio_controller (
    input wire clk,
    input wire reset,
    input wire mode, // 0 for input mode, 1 for output mode
    input wire [7:0] gpio_input,
    output reg [7:0] gpio_output
);
    reg [7:0] input_reg;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            gpio_output <= 8'b0;
            input_reg <= 8'b0;
        end else begin
            if (mode == 0) begin
                // Input Mode
                input_reg <= gpio_input;
            end else begin
                // Output Mode
                gpio_output <= input_reg;
            end
        end
    end
endmodule